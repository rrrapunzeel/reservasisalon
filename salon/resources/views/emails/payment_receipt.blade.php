<!DOCTYPE html>
<html>
<head>
    <title>Payment Receipt</title>
</head>
<body>
    <h1>Payment Receipt</h1>
    <p>Thank you for your payment!</p>
    
    <h2>Order Details</h2>
    <p>Order ID: {{ $order->id }}</p>
    <p>Order Date: {{ $order->created_at }}</p>
    
    <h2>Payment Details</h2>
    <p>Payment Amount: {{ $order->total }}</p>
    <!-- Tambahkan informasi pembayaran lainnya sesuai kebutuhan, seperti metode pembayaran, nomor transaksi, dll. -->
</body>
</html>
