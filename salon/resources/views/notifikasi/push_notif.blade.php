<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Push Notification Sender</title>
</head>
<body>
    <h1>Push Notification Sender</h1>
    <textarea id="notificationMessage" placeholder="Enter notification message"></textarea>
    <button onclick="sendNotification()">Send Notification</button>

    <script src="https://cdn.onesignal.com/sdks/OneSignalSDK.js" async></script>
    <script>
        // Inisialisasi OneSignal
        var OneSignal = window.OneSignal || [];
        OneSignal.push(function() {
            OneSignal.init({
                appId: "17d4c608-2426-41a0-8baf-da0609c5ea14",
            });
        });

        // Fungsi untuk mengirim notifikasi
        function sendNotification() {
            var message = document.getElementById("notificationMessage").value;

            // Kirim permintaan ke server Laravel menggunakan AJAX
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState === 4 && this.status === 200) {
                    alert("Notification sent successfully");
                } else {
                    alert("Failed to send notification");
                }
            };
            xhttp.open("POST", "{{ route('send-notification') }}", true);
            xhttp.setRequestHeader("Content-Type", "application/json");
            xhttp.send(JSON.stringify({ message: message, _token: "{{ csrf_token() }}" }));
        }
    </script>
</body>
</html>
