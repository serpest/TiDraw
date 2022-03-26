# TiDraw
TiDraw is a draw system based on client-server model designed to be as secure as possible. For this reason, the draw is executed by the server and users can't cheat altering the result.

It's possible to make the draw result appear from a selected date and time to enhance draw validity. In this way, the draw creator can share the draw link with other people before the draw instant to assure them that he/she hadn't generated multiple draws, waiting for the preferred result.

The draw creator can edit or delete the draw up to five minutes before its execution. The authorization system that permits this feature works under the hood using tokens and cookies, so the user doesn't have to remember a password or to create an account.

<div>
    <img src="https://user-images.githubusercontent.com/49209517/160253161-39ecb97a-3a4a-4335-afd7-72e042a38d8b.png" width="24%"/>
    <img src="https://user-images.githubusercontent.com/49209517/160253163-b730a41e-bedb-4859-929b-78c7582f1c62.png" width="24%"/>
    <img src="https://user-images.githubusercontent.com/49209517/160252896-6c68ffee-8308-4732-bf85-f7d636ded311.png" width="24%"/>
    <img src="https://user-images.githubusercontent.com/49209517/160252815-12fe7bbc-b50e-4e92-b617-633dfe92a6a6.png" width="24%"/>
</div>

## Deployment
1. [Create an application on Heroku](https://devcenter.heroku.com/articles/creating-apps);
2. [Set up the following buildpacks on Heroku](https://devcenter.heroku.com/articles/using-multiple-buildpacks-for-an-app) in the specified order:
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
