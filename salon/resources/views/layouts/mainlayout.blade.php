<!DOCTYPE html>
<html lang="en">

<head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <title>Challista Beauty Salon | @yield('title')</title>
        <meta content="" name="description">
        <meta content="" name="keywords">

          <!-- Favicons -->
        <link href="/NiceAdmin/assets/img/favicon.png" rel="icon">
        <link href="/NiceAdmin/assets/img/apple-touch-icon.png" rel="apple-touch-icon">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

        <!-- Google Fonts -->
        <link href="https://fonts.gstatic.com" rel="preconnect">
        <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">

        <!-- Vendor CSS Files -->
        <link href="/NiceAdmin/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
        <link href="/NiceAdmin/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
        <link href="/NiceAdmin/assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
        <link href="/NiceAdmin/assets/vendor/quill/quill.snow.css" rel="stylesheet">
        <link href="/NiceAdmin/assets/vendor/quill/quill.bubble.css" rel="stylesheet">
        <link href="/NiceAdmin/assets/vendor/remixicon/remixicon.css" rel="stylesheet">
        <link href="/NiceAdmin/assets/vendor/simple-datatables/style.css" rel="stylesheet">

        <!-- Template Main CSS File -->
        <link href="/NiceAdmin/assets/css/style.css" rel="stylesheet">
       
        <!-- CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">

<!-- JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">

<!-- JavaScript -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/css/bootstrap-datepicker.min.css">

<!-- JavaScript -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>




        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
        

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css" integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g==" crossorigin="anonymous" referrerpolicy="no-referrer" />

        <!-- =======================================================
        * Template Name: NiceAdmin - v2.5.0
        * Template URL: https://bootstrapmade.com/nice-admin-bootstrap-admin-html-template/
        * Author: BootstrapMade.com
        * License: https://bootstrapmade.com/license/
        ======================================================== -->

</head>

<body>

  <!-- ======= Header ======= -->
  <header id="header" class="header fixed-top d-flex align-items-center">

    <div class="d-flex align-items-center justify-content-between">
      <a href="" class="logo d-flex align-items-center">
        <img src="" alt="">
        <span class="d-none d-lg-block">Challista Beauty Salon</span>
      </a>
      <i class="bi bi-list toggle-sidebar-btn"></i>
    </div><!-- End Logo -->

    <div class="search-bar">
      <form class="search-form d-flex align-items-center" method="POST" action="#">
        <input type="text" name="query" placeholder="Search" title="Enter search keyword">
        <button type="submit" title="Search"><i class="bi bi-search"></i></button>
      </form>
    </div><!-- End Search Bar -->

    <nav class="header-nav ms-auto">
      <ul class="d-flex align-items-center">

        <li class="nav-item d-block d-lg-none">
          <a class="nav-link nav-icon search-bar-toggle " href="#">
            <i class="bi bi-search"></i>
          </a>
        </li><!-- End Search Icon-->

        <li class="nav-item dropdown pe-3">

          <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
          <i class="bi bi-person-circle" alt="Profile" class="rounded-circle"></i>
            <span class="d-none d-md-block dropdown-toggle ps-2">Profil</span>
          </a><!-- End Profile Image Icon -->


          <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
            <li class="dropdown-header">
              <h6>Admin</h6>
            </li>
            <li>
              <hr class="dropdown-divider">
            </li>

            <li>
    <a class="dropdown-item d-flex align-items-center" href="{{ route('logout') }}">
        <i class="bi bi-box-arrow-right"></i>
        <span>Sign Out</span>
    </a>
</li>


          </ul><!-- End Profile Dropdown Items -->
        </li><!-- End Profile Nav -->

      </ul>
    </nav><!-- End Icons Navigation -->

  </header><!-- End Header -->

  <!-- ======= Sidebar ======= -->
  <aside id="sidebar" class="sidebar">

<ul class="sidebar-nav" id="sidebar-nav">

  <li class="nav-item">
    <a class="nav-link collapsed" href="{{ route('dashboard.view') }}">
      <i class="bi bi-grid"></i>
      <span>Dashboard</span>
    </a>
  </li><!-- End Dashboard Nav -->

      <li class="nav-heading">Kelola</li>

      <li class="nav-item">
        <a class="nav-link collapsed" href="{{ route('kategori.index') }}">
            <i class="bi bi-list-task"></i>Kategori
        </a>
    </li>

      <li class="nav-item">
        <a class="nav-link collapsed" href="{{ route('perawatan.index') }}">
            <i class="bi bi-scissors"></i>Perawatan
        </a>
    </li>

    <li class="nav-item">
        <a class="nav-link collapsed" href="{{ route('jadwal.index') }}">
            <i class="bi bi-table"></i> Jadwal
        </a>
    </li>
 
    <li class="nav-item">
        <a class="nav-link collapsed" href="{{ route('reservasi.index') }}">
            <i class="bi bi-journal-text"></i> Daftar Reservasi
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link collapsed" href="{{ route('pembayaran.index') }}">
            <i class="bi bi-wallet2"></i> Daftar Pembayaran
        </a>
    </li>
  
      <li class="nav-heading">Pengguna</li>

      <li class="nav-item">
        <a class="nav-link collapsed" href="{{ route('pegawai.index') }}">
            <i class="bi bi-person-circle"></i> Pegawai
        </a>
    </li>
    <li class="nav-item">
        <a class="nav-link collapsed" href="{{ route('pelanggan.index') }}">
            <i class="bi bi-people-fill"></i> Pelanggan
        </a>
    </li>

    </ul>

  </aside><!-- End Sidebar-->

  <main id="main" class="main">

    @yield('content')

  </main><!-- End #main -->

  <!-- ======= Footer ======= -->
  <footer id="footer" class="footer">
    <div class="copyright">
      &copy; Challista Beauty Salon <strong><span> </span></strong>. 2023
    </div>
  </footer><!-- End Footer -->

  <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

  <!-- Vendor JS Files -->
  <script src="/NiceAdmin/assets/vendor/apexcharts/apexcharts.min.js"></script>
  <script src="/NiceAdmin/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="/NiceAdmin/assets/vendor/chart.js/chart.umd.js"></script>
  <script src="/NiceAdmin/assets/vendor/echarts/echarts.min.js"></script>
  <script src="/NiceAdmin/assets/vendor/quill/quill.min.js"></script>
  <script src="/NiceAdmin/assets/vendor/simple-datatables/simple-datatables.js"></script>
  <script src="/NiceAdmin/assets/vendor/tinymce/tinymce.min.js"></script>
  <script src="/NiceAdmin/assets/vendor/php-email-form/validate.js"></script>

  <!-- Template Main JS File -->
  <script src="/NiceAdmin/assets/js/main.js"></script>
  <scrip src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" integrity="sha512-VEd+nq25CkR676O+pLBnDW09R7VQX9Mdiij052gVCp5yVH3jGtH70Ho/UUv4mJDsEdTvqRCFZg0NKGiojGnUCw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

</body>

</html>