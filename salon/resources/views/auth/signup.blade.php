<!DOCTYPE html>
<html lang="en">

<head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <title>Challista Beauty Salon</title>
        <meta content="" name="description">
        <meta content="" name="keywords">

        <!-- Favicons -->
        <link href="/NiceAdmin/assets/img/favicon.png" rel="icon">
        <link href="/NiceAdmin/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

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

        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/bootstrap-icons.min.css" rel="stylesheet">

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
<main>
    <div class="container">

      <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
        <div class="container">
          <div class="row justify-content-center">
            <div class="col-lg-10 col-md-12 d-flex flex-column align-items-center justify-content-center">


              <div class="d-flex justify-content-center py-4">
                <a href="{{ route('dashboard.view') }}" class="logo d-flex align-items-center w-auto">
                  <img src="assets/images/logochallista.png" alt="">
                  <span class="d-none d-lg-block">Challista Beauty Salon</span>
                </a>
              </div><!-- End Logo -->

              <div class="card mb-3">
                <div class="card-body">
                  <div class="pt-4 pb-2">
                    <h5 class="card-title text-center pb-0 fs-4">Selamat Datang</h5>
                    <img src="assets/images/logochallista.png" alt="">
                    <p class="text-center small">Buat Akun</p>
                  </div>

                  <form class="row g-3 needs-validation" method="POST" action="{{ route('register.store') }}" novalidate>

                  <div class="col-12">
  <label for="yourUsername" class="form-label">Nama</label>
  <div class="input-group has-validation">
    <input type="text" name="email" class="form-control" id="email" required>
    <div class="invalid-feedback">Masukkan Nama</div>
  </div>
</div>

<div class="col-12">
  <label for="yourUsername" class="form-label">Email</label>
  <div class="input-group has-validation">
    <input type="text" name="email" class="form-control" id="email" required>
    <div class="invalid-feedback">Masukkan email</div>
  </div>
</div>

<div class="col-12">
  <label for="yourPassword" class="form-label">Password</label>
  <input type="password" name="password" class="form-control" id="passwrod" required>
  <div class="invalid-feedback">Masukkan kata sandi</div>
</div>

  <button class="btn btn-primary w-100" type="submit">Daftar</button>
</div>
<div class="col-12">
                      <p class="small mb-0">Sudah punya akun?<a href="{{ route ('login.view')}}">Masuk</a></p>
                    </div>
                  </form>

                </div>
            </div>
          </div>
        </div>
      </section>

    </div>
  </main><!-- End #main -->

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

</body>

</html>
