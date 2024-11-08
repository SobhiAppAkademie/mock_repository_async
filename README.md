# Mock Async Repository

Ein asynchrones Repository, das das Login und die Abfrage eines Nutzers simuliert.

## Roter Faden

**Wie gehe ich vor, um selbst ein Mock-Repository zu erstellen?**

### Schritt 1: Projekt vorbereiten
Beginne mit der Vorbereitung deines Projekts. Erstelle ein Flutter-Projekt und refaktoriere den Code gemäß der Feature-First/Layer-First-Architektur, die du aus der Vorlesung kennengelernt hast.

### Schritt 2: Design erstellen [Login-Screen]
Bereite nun deine Screens vor. Erstelle einen Login-Screen mit den folgenden Widgets:
  - E-Mail Textfeld
  - Passwort Textfeld
  - Login-Button
  - Loading Indicator
  - Text-Widget für die Erfolgsmeldung
  - Text-Widget für die Fehlermeldung
  - Variablen zum Speichern der Fehlermeldung, Erfolgsmeldung und des Loading-State.

Sobald du mit dem Design zufrieden bist, kannst du weitermachen.

### Schritt 3: User-Klasse erstellen
Erstelle unter dem Ordner `schema` die Datei `user.dart`. Du kannst auch eine andere Klasse verwenden, wenn du keinen `User` zurückgeben möchtest. 
Definiere alle Attribute für deine User-Klasse. Achte darauf, dass du ein Attribut für die `email` und das `password` hinzufügst, um das Login zu simulieren.

### Schritt 4: Repository erstellen
Erstelle im Ordner `repositories` die Datei `user_repository.dart`. Dort definierst du eine abstrakte Klasse als Vorlage für deine zukünftigen Repositories. 
Beachte, dass die Methoden mit einem `Future` markiert sind, da wir eine Abfrage zu einem Server simulieren, dessen Antwortzeit unbekannt ist.

Nun bist du an dem Punkt, an dem du dir denkst: "Okay, was gebe ich nun zurück?"

### Schritt 5: Klasse für den Server-Response erstellen
Erstelle eine Datei namens `server_user_response.dart` im Ordner `schema`. Diese enthält die Klasse `ServerUserResponse` mit folgenden drei Attributen:
- `User?` -> Du kannst eine andere Klasse verwenden, wenn du in **Schritt 3: User-Klasse erstellen** eine andere Klasse definiert hast. Wichtig ist das `?`, um das Attribut als `nullable` zu markieren. Das bedeutet, dass das Attribut auch `null` sein kann, etwa wenn das Login fehlgeschlagen ist.
- `success` -> Dieses Attribut gibt an, ob die Server-Anfrage erfolgreich (z.B. Login, Nutzer hinzufügen, Bild hochladen) war oder nicht.
- `errorMessage?` -> Falls die Server-Anfrage fehlgeschlagen ist, wird hier die Fehlermeldung gespeichert.

Falls du mehr Informationen zu einer simulierten Abfrage benötigst, kannst du weitere Attribute in dieser Klasse hinzufügen.

Nun kannst du diese Klasse in deinem `user_repository.dart` im `Future` angeben.

### Schritt 6: Mock-User-Repository erstellen
Erstelle im Ordner `repositories` die Datei `mock_user_repository.dart` und implementiere deine Vorlage aus **Schritt 4**. 
Implementiere deine Logik in der Methode und achte darauf, dass du immer ein `ServerUserResponse` zurückgibst.

#### Schritt 6A: Fiktive Datenbank (Optional)
Falls du eine fiktive Datenbank benötigst, kannst du eine Datei erstellen, in der du verschiedene User definierst. In unserem Beispiel haben wir zwei User in der Datei `mock_user_database.dart` definiert: einen normalen User und einen Admin-User.

### Schritt 7: User Service erstellen
Um die Abfrage zu simulieren und die Daten aus den Textfeldern abzurufen, erstelle unter dem Ordner `logic` die Datei `user_service.dart` mit der Klasse `UserService`. 
In der Klasse definierst du nun dein `MockUserRepository`. Ich empfehle, der Repository-Variable einen Unterstrich voranzustellen (z.B. `_mockUserRepository`), damit es von außen nicht zugreifbar ist.

Des Weiteren erstellst du zwei `TextEditingController` (einen für die E-Mail und einen für das Passwort), die später mit deinen TextField-Widgets verbunden werden.
Erstelle außerdem eine Methode wie `loginUser`, die die `login`-Methode aus deinem `MockUserRepository` aufruft. Hinweis: Du musst der Methode `loginUser` kein E-Mail/Passwort übergeben, da du bereits die nötigen Mittel (TextEditingController) in der Klasse hast.

### Schritt 8: Login-Screen bearbeiten
Nun hast du alle Schritte vorbereitet. Implementiere die `UserService`-Klasse in deinem Login-Screen und verbinde die `TextEditingController` aus der `UserService` mit deinen Textfeldern. 
Erstelle außerdem eine Methode namens `handleLogin(BuildContext context)` in deinem Login-Screen, die ausgeführt wird, wenn der Login-Button gedrückt wird. 
In dieser Methode kannst du nun die Abfrage aus der `UserService`-Klasse aufrufen und auf den Response warten. 
**Wichtig:** Du benötigst `async/await`. 
War die Abfrage erfolgreich? Falls nicht, wie lautet die Fehlermeldung? 
Passe den State basierend auf der Abfrage an (siehe **Schritt 1**, um zu sehen, wie du dies umsetzen kannst).

### BONUS
Erstelle ein `LoginRepository` und trenne die Abfrage vom User in ein `UserRepository`.
