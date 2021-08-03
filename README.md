# TiDraw
TiDraw is a draw system based on client-server model designed to be as secure as possible. For this reason, the draw is executed by the server and the users can't cheat altering the draw.

Another feature that enhances the security is having an option that makes the draw results appear from a selected date and time. In this way, the draw creator can share the draw link with other people before the draw instant to assure them that he/she hasn't generate more then one draw waiting for the preferred results.

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
    ```
4. [Create a MongoDB database and connect it to the application](https://www.mongodb.com/developer/how-to/use-atlas-on-heroku) using "spring.data.mongodb.uri" and not "MONGODB_URI" as Config Var key on Heroku;
5. Push application on Heroku running the following command:
    ``` shell
    git push heroku master
    ```
