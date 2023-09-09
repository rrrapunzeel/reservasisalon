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
    @method('POST')

    <div class="row mb-3">
        <label for="id_perawatan" class="col-sm-2 col-form-label">ID Perawatan</label>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="id_perawatan" name="id_perawatan" readonly value="{{ $defaultIdPerawatan }}" required>
            <!-- Adding the "required" attribute to make this field required -->
        </div>
    </div>

    <div class="row mb-3">
    <label for="id_kategori" class="col-sm-2 col-form-label">Kategori</label>
    <div class="col-sm-10">
        <select class="form-control" id="id_kategori" name="id_kategori" required>

            <!-- Adding the default option "Pilih Kategori" -->
            <option value="">Pilih Kategori</option>
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
            <input type="text" class="form-control" id="nama_perawatan" name="nama_perawatan" placeholder="Contoh: Creambath" required>
            <!-- Adding the "required" attribute to make this field required -->
        </div>
    </div>

    <div class="row mb-3">
        <label for="estimasi" class="col-sm-2 col-form-label">Durasi Perawatan</label>
        <div class="col-sm-10">
            <input type="text" class="form-control" id="estimasi" name="estimasi" placeholder="Contoh: 30" required>
            <!-- Adding the "required" attribute to make this field required -->
        </div>
    </div>

    <div class="row mb-3">
    <label for="harga_perawatan" class="col-sm-2 col-form-label">Harga Perawatan</label>
    <div class="col-sm-10">
        <input type="text" class="form-control" id="harga_perawatan" name="harga_perawatan" required pattern="[0-9]+" title="Silakan masukkan harga perawatan" placeholder="Contoh: 200000">
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
<script>
    // JavaScript to show the success alert for a few seconds after the page loads
    document.addEventListener('DOMContentLoaded', function () {
        let successAlert = document.getElementById('success-alert');
        if (successAlert) {
            // Show the alert for 3 seconds (3000 milliseconds)
            setTimeout(function () {
                successAlert.style.display = 'none';
            }, 3000);
        }
    });
</script>
@endpush
