@extends('layouts.mainlayout')
@extends('layouts.formlayout')

@section('title', 'Perawatan')
@section('content')
    <div class="pagetitle">
        <h1>Tambah Data</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
                <li class="breadcrumb-item"><a href="{{ route('perawatan.index') }}">Perawatan</a></li>
                <li class="breadcrumb-item active">Tambah</li>
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
                    <form action="{{ route('perawatan.store') }}" method="POST">
                        @csrf
                        <div class="row mb-3">
                            <label for="id_kategori" class="col-sm-2 col-form-label">Kategori</label>
                            <div class="col-sm-10">
                                <select class="form-control" id="id_kategori" name="id_kategori">
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
                                <input type="text" class="form-control" id="nama_perawatan" name="nama_perawatan" required>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <label for="harga_perawatan" class="col-sm-2 col-form-label">Harga Perawatan</label>
                            <div class="col-sm-10">
                                <input type="number" class="form-control" id="harga_perawatan" name="harga_perawatan" required>
                            </div>
                        </div>

                        <div class="text-center">
                            <button type="submit" class="btn btn-primary">Simpan</button>
                        </div>
                    </form>
                    <!-- End Horizontal Form -->
                </div>
            </div>
        </div>
    </section>
@endsection
