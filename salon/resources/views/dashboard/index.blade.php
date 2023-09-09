@extends('layouts.mainlayout')

@section('title', 'Perawatan')

@section('content')
<section class="section dashboard">
    <div class="row">

                <!-- Sales Card -->
                <div class="col-xxl-4 col-md-5">
                    <div class="card info-card sales-card">

                        <div class="card-body">
                            <h5 class="card-title">Reservasi <span>| Total</span></h5>

                            <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                    <i class="bi bi-cart"></i>
                                </div>
                                <div class="ps-3">
                                <h6>{{ count($reservasi) }}</h6>
                                    <span class="text-success small pt-1 fw-bold">Data Reservasi</span>

                                </div>
                            </div>
                        </div>

                    </div>
                </div><!-- End Sales Card -->

<!-- Revenue Card -->
<div class="col-xxl-4 col-md-7">
    <div class="card info-card revenue-card">
        <div class="card-body">
            <h5 class="card-title">Pembayaran <span>| Total</span></h5>
            <div class="d-flex align-items-center">
                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                    <i class="bi bi-wallet"></i>
                </div>
                <div class="ps-3">
                    <?php
                    // Assume $pembayarans is an array containing data from the API response
                    // You need to iterate through the array and sum up the total values
                    $totalRevenue = 0;
                    foreach ($pembayarans as $pembayaran) {
                        $totalRevenue += $pembayaran['total'];
                    }

                    // Calculate the percentage increase (you can modify this based on your calculation logic)
                    $previousMonthRevenue = 3000; // Assuming the revenue for the previous month
                    $percentageIncrease = (($totalRevenue - $previousMonthRevenue) / $previousMonthRevenue) * 100;
                    ?>
                    <h6>Rp<?php echo number_format($totalRevenue, 2); ?></h6>
                    <span class="text-success small pt-1 fw-bold">Data Pembayaran</span>
                </div>
            </div>
        </div>
    </div>
</div><!-- End Revenue Card -->



                <div class="card-body">
                  <h5 class="card-title">Data Reservasi</h5>

                  <table class="table table-borderless datatable">
            <thead>
                <tr>
                    <th scope="col">#</th>
                    <th scope="col">Nama</th>
                    <th scope="col">Pegawai</th>
                    <th scope="col">Perawatan</th>
                    <th scope="col">Tanggal</th>
                    <th scope="col">Jam</th>
                    <th scope="col">Status</th>
                    <th scope="col">Aksi</th>
                </tr>
            </thead>
            <tbody>
    @forelse($reservasi as $item)
    <tr>
        <th scope="row">{{ $loop->iteration }}</th>
        <td>{{ $item['nama'] }}</td>
        <td>{{ $item['pegawai'] }}</td>
        <td>
    @if (isset($item['items']) && is_array($item['items']))
        <ul>
            @foreach ($item['items'] as $perawatan)
                @if (isset($perawatan['name']))
                    <li>{{ $perawatan['name'] }}</li>
                @endif
            @endforeach
        </ul>
    @else
        Tidak ada item yang tersedia.
    @endif
</td>

        <td>{{ $item['tanggal'] }}</td>
        <td>{{ $item['jam'] }}</td>
        <td>
        @if ($item['transaction_status'] === 'Berhasil')
    <span class="badge bg-primary">{{ $item['transaction_status'] }}</span>
@elseif ($item['transaction_status'] === 'Lunas')
    <span class="badge bg-success">{{ $item['transaction_status'] }}</span>
            @elseif ($item['transaction_status'] === 'Tertunda')
                <span class="badge bg-warning">{{ $item['transaction_status'] }}</span>
            @elseif ($item['transaction_status'] === 'Gagal')
                <span class="badge bg-danger">{{ $item['transaction_status'] }}</span>
            @else
                <span class="badge">{{ $item['transaction_status'] }}</span>
            @endif
        </td>
        <td>
            <a href="{{ route('reservasi.update', $item['id']) }}" class="btn btn-outline-primary"><i class="bi bi-pencil-fill"></i></a>
            <form action="{{ route('reservasi.delete', $item['id']) }}" method="POST" class="d-inline">
                @csrf
                @method('DELETE')
                <button type="submit" class="btn btn-outline-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus perawatan ini?')"><i class="bi bi-trash-fill"></i></button>
            </form>
        </td>
    </tr>
    @empty
    <tr>
        <td colspan="8">Tidak ada data reservasi.</td>
    </tr>
    @endforelse
</tbody>
        </table>

                </div>

              </div>
            </div><!-- End Recent Sales -->
    </div>
</section>
@endsection
