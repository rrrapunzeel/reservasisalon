<!DOCTYPE html>
<html>
<head>
    <title>Invoice Reservasi | Challista Beauty Salon</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h2 {
            color: #F1768A;
        }

        img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 10px auto;
            /* Set a specific width for the image */
            width: 180px;
        }

        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .centered-text {
            text-align: center;
        }

        .rincian-box {
            background-color: #F1768A; /* Pink background */
            color: #fff; /* Text color */
            padding: 10px;
            border-radius: 0px;
            margin-top: 5px;
            font-weight: bold;
        }

        .order-id-box {
            background-color: #FFF;
            color: #444444;
            padding: 10px;
            border-radius: 8px;
            border: 2px solid #F1768A; /* Add pink outline */
            margin-top: 0; 
            opacity: 0.7;
        }

        .details-box {
            background-color: #FFF;
            color: #444444;
            padding: 10px;
            border-radius: 0px;
            border: 2px solid #F1768A; /* Add pink outline */
            margin-top: 0; /* Remove top margin */
        }

        ul {
            list-style: none;
            padding-left: 20px;
        }

        li:before {
            content: "\2022"; /* Bullet character */
            color: #ff3366;
            display: inline-block;
            width: 1em;
            margin-left: -1em;
        }

        .cta-btn {
            display: inline-block;
            background-color: #F1768A;
            color: #fff;
            text-decoration: none;
            padding: 10px 20px;
            border-radius: 4px;
            margin-top: 20px;
        }

        /* Add flexbox styles to center the CTA button */
        .cta-container {
            display: flex;
            justify-content: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="centered-text">Terima kasih telah reservasi di Challista Beauty Salon!</h2>
        <img src="https://d375w6nzl58bw0.cloudfront.net/uploads/775b168e8df706334f3bd2a144d9b152096098c309634463563aab033fa363da.png" alt="Challista Beauty Salon">
        <h2 class="centered-text">Halo, {{ $nama }}</h2>
        <!-- Add the "order-id-box" class to the "Order ID" paragraph -->
        <p class="order-id-box centered-text">Order ID {{ $orderId }}</p>

        <div class="rincian-box centered-text">
    <p>Rincian Reservasi</p>
</div>

<div class="details-box">
            <p>Pegawai   : {{ $pegawai ?? 'Data tidak tersedia' }}</p>
            <p>Jadwal    : {{ isset($selectedDateTime) ? \Carbon\Carbon::parse($selectedDateTime)->isoFormat('YYYY-MM-DD | HH:mm') : 'Data tidak tersedia' }}</p>
            <p>Perawatan : </p>
            @if (isset($items) && is_array($items) && count($items) > 0)
                <ul>
                    @foreach ($items as $perawatan)
                        @if (isset($perawatan['name']) && isset($perawatan['price']))
                            <li> • {{ $perawatan['name'] }} : Rp{{ number_format($perawatan['price'], 0, ',', '.') }}</li>
                        @endif
                    @endforeach
                </ul>
            @else
                <p>Tidak ada perawatan.</p>
            @endif
        </div>

        @php
            $totalHarga = $total * 2;
        @endphp

        <div class="details-box">
            <p>Total Terbayar  : Rp{{ number_format($total, 0, ',', '.') }}</p>
            <p>Total Pelunasan : Rp{{ number_format($total, 0, ',', '.') }}</p>
            <p>Total Harga     : Rp{{ number_format($totalHarga, 0, ',', '.') }}</p>
        </div>

        <p>Kamu bisa melihat kembali reservasi di "Daftar Pesanan" di dalam akun Challista Beauty Salon kamu</p>

        <p>Jangan lupa datang tepat waktu ya! Kami telah menambahkan jadwal reservasi kamu ke Google Calendar pribadi kamu, yuk cek di bawah ini!</p>

        <!-- Wrap the CTA button in a div with "cta-container" class to center it -->
        <div class="cta-container">
            <a href="https://www.google.com/calendar/render?tab=mc&pli=1#main_7%7Cmonth,202307" target="_blank" class="cta-btn centered-text">Lihat Reminder</a>
        </div>
    </div>
</body>
</html>
