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
                <div class="alert alert-success mt-3" id="success-alert">
                    {{ session('success') }}
                </div>
                @endif

                <form action="{{ url('/perawatan/updatestore', $id_perawatan) }}" method="PATCH">
                    @csrf
                    @method('PATCH')

                    <div class="row mb-3">
                        <label for="id_perawatan" class="col-sm-2 col-form-label">ID Perawatan</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" id="id_perawatan" name="id_perawatan" value="{{ $id_perawatan }}" readonly>
                        </div>
                    </div>

                    <div class="row mb-3">
        <label for="id_kategori" class="col-sm-2 col-form-label">Kategori</label>
        <div class="col-sm-10">
            <select class="form-control" id="id_kategori" name="id_kategori" required>
            @if (is_array($kategoris) || is_object($kategoris))
                @foreach($kategoris as $kategori)
                    <option value="{{ $kategori->id_kategori }}">{{ $kategori->nama_kategori }}</option>
                @endforeach
            @endif
            </select>
        </div>
    </div>

                    <div class="row mb-3">
                        <label for="nama_perawatan" class="col-sm-2 col-form-label">Nama Perawatan</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="nama_perawatan" id="nama_perawatan" value="{{ $kategoriItem->nama_perawatan }}" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label for="estimasi" class="col-sm-2 col-form-label">Durasi Perawatan</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="estimasi" id="estimasi" value="{{ $kategoriItem->estimasi }}" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label for="harga_perawatan" class="col-sm-2 col-form-label">Harga Perawatan</label>
                        <div class="col-sm-10">
                            <input type="number" class="form-control" name="harga_perawatan" id="harga_perawatan" value="{{ $kategoriItem->harga_perawatan }}" required>
                        </div>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-primary">Simpan</button>
                        <a href="{{ url('/perawatan/index') }}" class="btn btn-danger">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>
@endsection
