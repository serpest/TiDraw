# TiDraw
TiDraw is a draw system based on client-server model designed to be as secure as possible. For this reason, the draw is executed by the server and the users can't cheat altering the draw.

Another feature that enhances the security is having an option that makes the draw results appear from a selected date and time. In this way, the draw creator can share the draw link with other people before the draw instant to assure them that he/she hadn't generated more then one draw waiting for the preferred results.

<div>
    <img src="https://user-images.githubusercontent.com/49209517/135277039-05b0e67c-ab9d-4287-8ee3-509e8b207314.png" width="24%"/>
    <img src="https://user-images.githubusercontent.com/49209517/135277126-c409c516-ea44-4167-9c4e-072873a0d97e.png" width="24%"/>
    <img src="https://user-images.githubusercontent.com/49209517/135277775-b816d1f6-f4d2-4b72-8ceb-d90b652d38aa.png" width="24%"/>
    <img src="https://user-images.githubusercontent.com/49209517/135277806-3cab378d-fd9c-4ed1-9ab7-742bbd047ca4.png" width="24%"/>
</div>

## Deployment
1. [Create an application on Heroku](https://devcenter.heroku.com/articles/creating-apps);
2. [Set up the following buildpacks in the specified order on Heroku](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app):
    ``` properties
    1. ee\heroku-buildpack-flutter-light
    2. heroku\java
    ```
3. [Configure the following Config Vars on Heroku](https://devcenter.heroku.com/articles/config-vars):
    ``` properties
    FLUTTER_DEPLOY_DIR=src/main/resources/static
    FLUTTER_SOURCE_DIR=src/main/webapp
    FLUTTER_BUILD=flutter build web --release --dart-define=DRAW_ID_LENGTH=24
    ```
4. [Create a MongoDB database and connect it to the application](https://www.mongodb.com/developer/how-to/use-atlas-on-heroku) using "spring.data.mongodb.uri" and not "MONGODB_URI" as Config Var key on Heroku;
5. Push application to Heroku running the following command:
    ``` shell
    git push heroku master
    ```
