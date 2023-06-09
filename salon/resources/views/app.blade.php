<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{ config('app.name', 'My Laravel App') }}</title>
    <!-- Masukkan tautan stylesheet Anda di sini -->
</head>
<body>
    <header>
        <!-- Tampilkan header situs Anda di sini -->
    </header>

    <main>
        <!-- Tampilkan konten utama halaman di sini -->
        @yield('content')
    </main>

    <footer>
        <!-- Tampilkan footer situs Anda di sini -->
    </footer>

    <!-- Masukkan skrip JavaScript Anda di sini -->
</body>
</html>
