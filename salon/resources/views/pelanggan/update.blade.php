@extends('layouts.mainlayout')
@extends('layouts.formlayout')

@section('title', 'Pelanggan')

@section('content')
<div class="pagetitle">
        <h1>Edit Data</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="{{ route('pelanggan.index') }}">Pelanggan</a></li>
            <li class="breadcrumb-item active">Edit</li>
          </ol>
        </nav>
      </div><!-- End Page Title -->
      <section class="section">
        <div class="row">
          <div class="card">
              <div class="card-body">
                <h5 class="card-title">Pelanggan</h5>
                @if(session('success'))
        <div class="alert alert-success mt-3">
          {{ session('success') }}
        </div>
        @endif

        <form action="{{ url('/pelanggan/updatestore', $pelanggan['id']) }}" method="POST">
    @csrf
    @method('PATCH')
            @csrf
            @method('PATCH')

            <div class="row mb-3">
                <label for="nama" class="col-sm-2 col-form-label">Nama</label>
                <div class="col-sm-10">
                <input type="text" class="form-control" name="nama" id="nama" value="{{ $pelanggan['nama'] }}" required>
            </div>
        </div>

        <div class="row mb-3">
                <label for="email" class="col-sm-2 col-form-label">Email</label>
                <div class="col-sm-10">
                <input type="text" class="form-control" name="email" id="email" value="{{ $pelanggan['email'] }}" required>
            </div>
        </div>

        <div class="row mb-3">
                <label for="nomor_telepon" class="col-sm-2 col-form-label">Nomor Telepon</label>
                <div class="col-sm-10">
                <input type="text" class="form-control" name="nomor_telepon" id="nomor_telepon" value="{{ $pelanggan['nomor_telepon'] }}" required>
            </div>
        </div>

        <div class="text-center">
                <button type="submit" class="btn btn-primary">Simpan</button>
                <a href="{{ url('/pelanggan/select') }}" class = "btn btn-danger">Batal</a>
            </div>
        </form>
    </div>
@endsection
