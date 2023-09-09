@extends('layouts.mainlayout')

@section('title', 'Pegawai')

@section('content')
<div class="pagetitle">
    <h1>Edit Data</h1>
    <nav>
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="{{ route('pegawai.index') }}">Pegawai</a></li>
            <li class="breadcrumb-item active">Edit</li>
        </ol>
    </nav>
</div><!-- End Page Title -->
<section class="section">
    <div class="row">
        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Pegawai</h5>
                @if(session('success'))
                <div class="alert alert-success mt-3">
                    {{ session('success') }}
                </div>
                @endif

                <form action="{{ url('/pegawai/updatestore', $pegawai['id']) }}" method="POST">
                    @csrf
                    @method('PATCH')

                    <div class="row mb-3">
                        <label for="nama" class="col-sm-2 col-form-label">Nama</label>
                        <div class="col-sm-10">
                            <input type="text" name="nama" id="nama" class="form-control" value="{{ $pegawai['nama'] }}" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <label for="status" class="col-sm-2 col-form-label">Status</label>
                        <div class="col-sm-10">
                        <select class="form-control" name="status" id="status" required>
    <option value="1" {{ isset($pegawai['status']) && $pegawai['status'] == 1 ? 'selected' : '' }}>Aktif</option>
    <option value="2" {{ isset($pegawai['status']) && $pegawai['status'] == 2 ? 'selected' : '' }}>Tidak Aktif</option>
</select>

                        </div>
                    </div>

                    <div class="text-center">
                        <button type="submit" class="btn btn-primary">Simpan</button>
                        <a href="{{ url('/pegawai/index') }}" class="btn btn-danger">Batal</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>
@endsection
