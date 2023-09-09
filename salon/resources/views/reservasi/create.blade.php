@extends('layouts.mainlayout')

@section('title', 'Reservasi')
@section('content')

    <div class="pagetitle">
        <h1>Tambah Data</h1>
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="{{ route('dashboard.view') }}">Dashboard</a></li>
                <li class="breadcrumb-item"><a href="{{ route('reservasi.index') }}">Reservasi</a></li>
                <li class="breadcrumb-item active">Tambah</li>
            </ol>
        </nav>
    </div><!-- End Page Title -->
    <section class="section">
        <div class="row">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">Reservasi</h5>
                    @if(session('success'))
                        <div class="alert alert-success mt-3">
                            {{ session('success') }}
                        </div>
                    @endif
                    <form action="{{ route('reservasi.store') }}" method="POST">
    @csrf
    @method('POST')

    <div class="row mb-3">
        <label for="nama" class="col-sm-2 col-form-label">Nama</label>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="nama" name="nama" placeholder="Masukkan nama" required>
        </div>
    </div>

    <div class="row mb-3">
    <label for="pegawai" class="col-sm-2 col-form-label">Pegawai</label>
    <div class="col-sm-10">
        <select class="form-control" id="pegawai" name="pegawai" required>

            <!-- Adding the default option "Pilih Kategori" -->
            <option value="">Pilih Pegawai</option>
            @if (is_array($pegawais) || is_object($pegawais))
                @foreach($pegawais as $pegawai)
                    <option value="{{ $pegawai->nama }}">{{ $pegawai->nama }}</option>
                @endforeach
            @endif
        </select>
    </div>
</div>

<div class="row mb-3">
    <label for="perawatan" class="col-sm-2 col-form-label">Perawatan</label>
    <div class="col-sm-10">
        <select class="form-control" id="perawatan" name="perawatan" required>

            <!-- Adding the default option "Pilih Kategori" -->
            <option value="">Pilih Perawatan</option>
            @if (is_array($perawatans) || is_object($perawatans))
                @foreach($perawatans as $perawatan)
                <option value="{{ $perawatan->id_perawatan }}">{{ $perawatan->nama_perawatan }}</option>
                @endforeach
            @endif
        </select>
    </div>
</div>


<div class="row mb-3">
        <label class="col-sm-2 col-form-label">Tanggal</label>
        <div class="col-sm-10">
            <div class="input-group">
                <input type="date" class="form-control datepicker" id="tanggal" name="tanggal" required>
            </div>
        </div>
    </div>

<div class="row mb-3">
    <label for="jam" class="col-sm-2 col-form-label">Jam</label>
    <div class="col-sm-10">
        <select class="form-control" id="jam" name="jam" required>
            <!-- Adding the default option "Pilih Jam" -->
            <option value="">Pilih Jam</option>
            @foreach ($uniqueJamPerawatan as $jamPerawatan)
                <option>{{ $jamPerawatan }}</option>
            @endforeach
        </select>
    </div>
</div>

<div class="row mb-3">
    <label for="status" class="col-sm-2 col-form-label">Status</label>
    <div class="col-sm-10">
    <input type="text" class="form-control" id="status" name="status" value="Menunggu Konfirmasi" readonly>
    </div>
</div>


</div>

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

@push('scripts')
<!-- Include the necessary JavaScript libraries -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.9.0/js/bootstrap-datepicker.min.js"></script>

<script>
    // Inisialisasi date picker when the button is clicked
    $(document).ready(function () {
        $('#tanggalPickerBtn').click(function() {
            $('#tanggal').datepicker({
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayHighlight: true
            }).datepicker('show');
        });
    });
</script>
@endpush

<!DOCTYPE html>
<html lang="en">
<!-- Rest of your HTML -->
</html>


