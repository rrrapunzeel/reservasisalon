@extends('layouts.mainlayout')

@section('title', 'Pegawai')
@section('content')

<div class="card">
    <div class="card-body">
        <h5 class="card-title">Tambah Data</h5>

        <form action="{{ route('pegawai.store') }}" method="POST">
            @csrf
            @method('POST')

            <div class="row mb-3">
                <label for="nama" class="col-sm-2 col-form-label">Nama</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="nama" name="nama" required>
                </div>
            </div>

            <div class="row mb-3">
                <label for="status" class="col-sm-2 col-form-label">Status</label>
                <div class="col-sm-10">
                    <select class="form-control" id="status" name="status" required>
                    <option value="">Pilih Status</option>
                        <option value="1">Aktif</option>
                        <option value="2">Tidak Aktif</option>
                    </select>
                </div>
            </div>

            <div class="text-center">
                <button type="submit" class="btn btn-primary">Simpan</button>
            </div>
        </form><!-- End Horizontal Form -->

    </div>
</div>

@endsection
