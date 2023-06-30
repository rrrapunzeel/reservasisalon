  @extends('layouts.mainlayout')
  @extends('layouts.formlayout')

  @section('title', 'Kategori')

  @section('content')
  <div class="pagetitle">
        <h1>Tambah Data</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="{{ route('kategori.index') }}">Kategori</a></li>
            <li class="breadcrumb-item active">Tambah</li>
          </ol>
        </nav>
      </div><!-- End Page Title -->
      <section class="section">
        <div class="row">
          <div class="card">
              <div class="card-body">
                <h5 class="card-title">Kategori</h5>
                @if(session('success'))
        <div class="alert alert-success mt-3">
          {{ session('success') }}
        </div>
        @endif
        <!-- Horizontal Form -->
        <form action="{{ route('kategori.store') }}" method="GET">
          @csrf
          @method('POST')
          <div class="row mb-3">
            <label for="inputEmail3" class="col-sm-2 col-form-label">Nama Kategori</label>
            <div class="col-sm-10">
              <input type="text" class="form-control" id="nama_kategori" name="nama_kategori" required>
            </div>
          </div>

          <div class="text-center">
            <button type="submit" class="btn btn-primary">Simpan</button>
          </div>
        </form><!-- End Horizontal Form -->


      </div>
  </div>
  @endsection
