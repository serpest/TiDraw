import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidraw/api.dart' as api;
import 'package:tidraw/model/draw.dart';
import 'package:tidraw/pages/edit_draw.dart';
import 'package:tidraw/utils/constants.dart' as constants;
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
  String? token;

  @override
  void initState() {
    super.initState();
    drawFuture = getDrawAndSetToken();
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
            icon: Icon(Icons.info_outline),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Additional informations'),
                      content: FutureBuilder<Draw>(
                        future: drawFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            String creationInstantStr = (snapshot.data!.creationInstant != null) ?
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.creationInstant!.toLocal()) : 'Unknown';
                            String lastModifiedInstantStr = (snapshot.data!.lastModifiedInstant != null) ?
                              DateFormat('yyyy-MM-dd HH:mm:ss').format(snapshot.data!.lastModifiedInstant!.toLocal()) : 'Unknown';
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                              ],
                            );
                          } else if (snapshot.hasError) {
                            if (snapshot.error is api.ApiException) {
                              return Text(snapshot.error.toString());
                            } else {
                              return Text('Unexpected error');
                            }
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close')
                        ),
                      ],
                    );
                  },
                );
              },
            tooltip: 'Additional informations',
          ),
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
                      color: Colors.grey,
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
                      color: Colors.grey,
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
                              // Using this approach, the client doesn't have to send multiple requests to the server,
                              // but, on the other hand, if the creator anticipates the draw instant, the spectators can't
                              // see the result in the new draw instant without refreshing the page.
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
                return Text('Unexpected error');
              }
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FutureBuilder<bool>(
        future: editableFlagFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data! && token != null) {
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DrawPage(id: widget.id);
                        }
                      )
                    );
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

  Future<Draw> getDrawAndSetToken() async {
    final storedTokens = await SharedPreferences.getInstance();
    token = storedTokens.getString(constants.TOKEN_KEY_PREFIX + widget.id);
    Draw draw = await api.getDraw(widget.id);
    if (draw.selectedElements == null) {
      Future.delayed(draw.drawInstant!.difference(DateTime.now()), () => drawFuture = getDrawAndSetToken());
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
    Future.delayed(Duration(milliseconds: 500), () => setState(() {}));
    return 'Less then a second';
  }
}
