@extends('layouts.mainlayout')

@extends('layouts.formlayout')

@section('title', 'Perawatan')
@section('content')
<div class="pagetitle">
        <h1>Edit Perawatan</h1>
        <nav>
          <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="{{ route('perawatan.index') }}">Kategori</a></li>
            <li class="breadcrumb-item active">Edit</li>
          </ol>
        </nav>
      </div><!-- End Page Title -->
      <section class="section">
        <div class="row">
          <div class="card">
              <div class="card-body">
                <h5 class="card-title">Perawatan</h5>
                @if(session('success'))
        <div class="alert alert-success mt-3">
          {{ session('success') }}
        </div>
        @endif

        <form action="{{ url('/perawatan/updatestore',$perawatan['id_perawatan']) }}" method="PATCH">
            @csrf
            @method('PATCH')

            <div class="row mb-3">\
                <label for="id_kategori" class="col-sm-2 col-form-label">Kategori</label>
                <div class="row mb-3">
                <select name="id_kategori" id="id_kategori" class="form-control">
                    <!-- Populate options with categories data -->
                    @foreach ($categories as $category)
                        <option value="{{ $category->id_kategori }}" @if ($category->id_kategori === $perawatan->id_kategori) selected @endif>{{ $category->nama_kategori }}</option>
                    @endforeach
                </select>
            </div>

            <div class="row mb-3">
                <label for="nama_perawatan" class="col-sm-2 col-form-label">Perawatan</label>
                <input type="text" name="nama_perawatan" id="form-control" value="{{ $perawatan->nama_perawatan }}" required>
            </div>

            <div class="row mb-3">
                <label for="harga_perawatan" class="col-sm-2 col-form-label">Harga</label>
                <input type="number" name="harga_perawatan" id="harga_perawatan" class="form-control" value="{{ $perawatan->harga_perawatan }}" required>
            </div>

            <div class="text-center">
            <button type="submit" class="btn btn-primary">Simpan</button>
                <a href="{{ url('/perawatan/index') }}" class = "btn btn-danger">Batal</a>
            </div>
        </form>
    </div>
@endsection
