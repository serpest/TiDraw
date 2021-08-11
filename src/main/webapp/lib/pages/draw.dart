import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tidraw/api.dart' as api;
import 'package:tidraw/model/draw.dart';
import 'package:tidraw/pages/edit_draw.dart';
import 'package:tidraw/utils/string_format_extension.dart';

class DrawPage extends StatefulWidget {
  static const route = '/draws/%s';

  final String id;

  DrawPage({Key? key, required this.id}) : super(key: key);

  @override
  _DrawPageState createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  late Future<Draw> drawFuture;
  late Future<bool> editableFlagFuture;

  @override
  void initState() {
    super.initState();
    drawFuture = getDraw();
    editableFlagFuture = getEditableFlagFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                'Check out my draw at ' + Uri.base.toString(),
                subject: 'Draw link',
              );
            },
            tooltip: 'Share draw',
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<Draw>(
          future: drawFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String creationInstantStr = (snapshot.data!.creationInstant != null) ?
                DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.creationInstant!.toLocal()) : 'Unknown';
              String lastModifiedInstantStr = (snapshot.data!.lastModifiedInstant != null) ?
                DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.lastModifiedInstant!.toLocal()) : 'Unknown';
              String drawInstantStr = (snapshot.data!.drawInstant != null) ?
                DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.drawInstant!.toLocal()) : lastModifiedInstantStr;
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.label),
                        labelText: 'Name',
                      ),
                      initialValue: snapshot.data!.name,
                      enabled: false,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.access_time),
                        labelText: 'Creation instant',
                      ),
                      initialValue: creationInstantStr,
                      enabled: false,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.access_time),
                        labelText: 'Last modified instant',
                      ),
                      initialValue: lastModifiedInstantStr,
                      enabled: false,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.access_time),
                        labelText: 'Draw instant',
                      ),
                      initialValue: drawInstantStr,
                      enabled: false,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.star),
                        labelText: 'Number of selected elements',
                      ),
                      initialValue: snapshot.data!.selectedElementsSize.toString(),
                      enabled: false,
                    ),
                    Divider(
                      height: 32.0,
                    ),
                    Text('Raffle elements'),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(8.0),
                        itemCount: snapshot.data!.raffleElements.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(snapshot.data!.raffleElements[index]),
                              leading: Text((index + 1).toString() + '.'),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 32.0,
                    ),
                    Text('Selected elements'),
                    Expanded(
                      child: (snapshot.data!.selectedElements != null) ? 
                        ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: snapshot.data!.selectedElements!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(snapshot.data!.selectedElements![index]),
                                leading: Text((index + 1).toString() + '.'),
                              ),
                            );
                          },
                        ) :
                        Center(
                          child: Card(
                            child: ListTile(
                              title: Text(getDurationStrAndScheduleNextViewRefresh(snapshot.data!.drawInstant!.difference(DateTime.now())) + ' to the draw execution'),
                              leading: Icon(
                                Icons.warning_amber_outlined,
                                color: Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              if (snapshot.error is api.ApiException) {
                return Text(snapshot.error.toString());
              } else {
                // TODO
                return Text('Unknown error');
              }
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: editableFlagFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!) { // TODO: && document.cookie != null && document.cookie!.contains(widget.id + '=')
            return FloatingActionButton(
              child: Icon(Icons.edit),
              tooltip: 'Edit draw',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  EditDrawPage.route.format([widget.id]),
                ).then((value) {
                  assert (value == null || value is bool);
                  if (value != null && value as bool) {
                    // Reload DrawPage
                    Navigator.popAndPushNamed(context, DrawPage.route.format([widget.id]));
                  }
                });
              },
            );
          }
          return Container(); // FutureBuilder's builder can't return null, so it returns an empty container
        },
      ),
    );
  }

  Future<Draw> getDraw() async {
    Draw draw = await api.getDraw(widget.id);
    if (draw.selectedElements == null) {
      Future.delayed(draw.drawInstant!.difference(DateTime.now()), () => drawFuture = getDraw());
    }
    return draw;
  }

  Future<bool> getEditableFlagFuture() async {
    DateTime noEditableInstant = await api.getNoEditableInstant(widget.id);
    bool editableFlag = noEditableInstant.isAfter(DateTime.now());
    if (editableFlag) {
      Future.delayed(noEditableInstant.difference(DateTime.now()), () => editableFlagFuture = getEditableFlagFuture());
    }
    return editableFlag;
  }

  String getDurationStrAndScheduleNextViewRefresh(Duration duration) {
    if (duration.inDays > 0) {
      Future.delayed(Duration(hours: 2), () => setState(() {}));
      return 'Less then ' + (duration.inDays + 1).toString() + ' days';
    } else if (duration.inHours > 0) {
      Future.delayed(Duration(minutes: 5), () => setState(() {}));
      return 'Less then ' + (duration.inHours + 1).toString() + ' hours';
    } else if (duration.inMinutes > 0) {
      Future.delayed(Duration(seconds: 5), () => setState(() {}));
      return 'Less then ' + (duration.inMinutes + 1).toString() + ' minutes';
    } else if (duration.inSeconds > 0) {
      Future.delayed(Duration(seconds: 1), () => setState(() {}));
      return duration.inSeconds.toString() + ' seconds';
    }
    return 'Less then a second';
  }
}
