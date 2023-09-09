@extends('layouts.mainlayout')
@extends('layouts.formlayout')

@section('title', 'Kategori')

@section('content')
<div class="pagetitle">
        <h1>Edit Data</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="{{ route('kategori.index') }}">Kategori</a></li>
            <li class="breadcrumb-item active">Edit</li>
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

        <form action="{{ url('/kategori/updatestore', $kategori['id_kategori']) }}" method="PATCH">
            @csrf
            @method('PATCH')

            <div class="row mb-3">
                <label for="nama_kategori" class="col-sm-2 col-form-label">Nama Kategori</label>
                <div class="col-sm-10">
                <input type="text" class="form-control" name="nama_kategori" id="nama_kategori" value="{{ $kategori['nama_kategori'] }}" required>
            </div>
        </div>

        <div class="text-center">
                <button type="submit" class="btn btn-primary">Simpan</button>
                <a href="{{ url('/kategori/index') }}" class = "btn btn-danger">Batal</a>
            </div>
        </form>
    </div>
@endsection
