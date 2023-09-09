<?
require 'vendor/autoload.php';

use Symfony\Component\Mime\Email;
use Symfony\Component\Mime\Address;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport\Smtp\EsmtpTransport;
use Symfony\Component\Mailer\Transport\Smtp\Auth\AuthenticatorInterface;

// Create the email
$email = (new Email())
    ->from(new Address('jasminepratiwiputrii@gmail.com', 'Challista Beauty Salon'))
    ->to(new Address('jasminepratiwiputriii@gmail.com', 'Jasmine'))
    ->subject('Test Email')
    ->text('This is a test email.');

// Configure the SMTP transport
$smtpHost = 'smtp.sendgrid.net';
$smtpPort = 587;
$smtpUsername = 'Tkt_nY4tTPK6G6d0MEjEFA';
$smtpPassword = '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';

class CustomAuthenticator implements AuthenticatorInterface {
    private $username;
    private $password;

    public function __construct(string $username, string $password) {
        $this->username = $username;
        $this->password = $password;
    }

    public function authenticate(EsmtpTransport $transport): void {
        $transport->setUsername($this->username);
        $transport->setPassword($this->password);
    }

    public function getAuthKeyword(): string {
        return 'LOGIN'; // Use 'LOGIN' as the authentication keyword
    }
}

$authenticator = new CustomAuthenticator($smtpUsername, $smtpPassword);
$transport = new EsmtpTransport($smtpHost, $smtpPort);
$authenticator->authenticate($transport);

// Send the email
$mailer = new Mailer($transport);
$mailer->send($email);
