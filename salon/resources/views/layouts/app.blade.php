<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        .container {
            display: grid;
            grid-template-columns: auto 1fr;
            grid-template-areas: "sidebar content";
        }

        .sidebar {
            grid-area: sidebar;
            background-color: #F2F2F2;
            padding: 10px;
        }

        .sidebar h5 {
            color: #000;
            margin-bottom: 15px;
        }

        .sidebar .nav-link {
            color: #000;
            display: flex;
            align-items: center;
        }

        .sidebar .nav-link .fa {
            margin-right: 5px;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background-color: #E9ECEF;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="sidebar">
            <h5>Menu</h5>
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="{{ route('perawatan.index') }}">
                        <i class="fas fa-chart-line"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{{ route('perawatan.index') }}">
                        <i class="fas fa-clipboard"></i> Perawatan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{{ route('perawatan.index') }}">
                        <i class="fas fa-tags"></i> Kategori
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{{ route('perawatan.index') }}">
                        <i class="fas fa-users"></i> Pelanggan
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{{ route('perawatan.index') }}">
                        <i class="fas fa-calendar-alt"></i> Reservasi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="{{ route('perawatan.index') }}">
                        <i class="fas fa-money-bill"></i> Pembayaran
                    </a>
                </li>
                <!-- Tambahkan menu lain di sini sesuai kebutuhan -->
            </ul>
        </div>

        <div class="content">
            @yield('content')
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>

</html>
