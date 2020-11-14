import 'package:mailer/smtp_server.dart';

SmtpServer trapMail(String username, String password) =>
    SmtpServer('smtp.mailtrap.io',
        ssl: true, port: 2525, username: username, password: password);
