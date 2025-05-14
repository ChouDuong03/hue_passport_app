import 'package:hue_passport_app/models/location_model_2.dart';

class LocationModel {
  final int id;
  final String? anhDaiDien;
  final String? soGiayPhep;
  final int? linhVucKinhDoanhId;
  final int hangSao;
  final int? loaiHinhId;
  final int dienTichMatBang;
  final int soTang;
  final String? soNha;
  final int phuongXaId;
  final int quanHuyenId;
  final int tinhThanhId;
  final String? soDienThoai;
  final String? fax;
  final String? email;
  final String? website;
  final String? hoTenNguoiDaiDien;
  final String? thoiDiemBatDauKinhDoanh;
  final String gioDongCua;
  final String gioMoCua;
  final double toaDoX;
  final double toaDoY;
  final int banKinhQuyUoc;
  final String? ngayCVDatChuan;
  final String? soCVDatChuan;
  final int? nhaCungCapId;
  final String? phucVu;
  final String? maDoanhNghiep;
  final bool thuocHoChieu;
  final List<LocationDetail> childGetDiaDiemByMonAns;

  LocationModel({
    required this.id,
    this.anhDaiDien,
    this.soGiayPhep,
    this.linhVucKinhDoanhId,
    required this.hangSao,
    this.loaiHinhId,
    required this.dienTichMatBang,
    required this.soTang,
    this.soNha,
    required this.phuongXaId,
    required this.quanHuyenId,
    required this.tinhThanhId,
    this.soDienThoai,
    this.fax,
    this.email,
    this.website,
    this.hoTenNguoiDaiDien,
    this.thoiDiemBatDauKinhDoanh,
    required this.gioDongCua,
    required this.gioMoCua,
    required this.toaDoX,
    required this.toaDoY,
    required this.banKinhQuyUoc,
    this.ngayCVDatChuan,
    this.soCVDatChuan,
    this.nhaCungCapId,
    this.phucVu,
    this.maDoanhNghiep,
    required this.thuocHoChieu,
    required this.childGetDiaDiemByMonAns,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['resultObj']['id'] as int,
      anhDaiDien: json['resultObj']['anhDaiDien'] as String?,
      soGiayPhep: json['resultObj']['soGiayPhep'] as String?,
      linhVucKinhDoanhId: json['resultObj']['linhVucKinhDoanhId'] as int?,
      hangSao: json['resultObj']['hangSao'] as int,
      loaiHinhId: json['resultObj']['loaiHinhId'] as int?,
      dienTichMatBang: json['resultObj']['dienTichMatBang'] as int,
      soTang: json['resultObj']['soTang'] as int,
      soNha: json['resultObj']['soNha'] as String?,
      phuongXaId: json['resultObj']['phuongXaId'] as int,
      quanHuyenId: json['resultObj']['quanHuyenId'] as int,
      tinhThanhId: json['resultObj']['tinhThanhId'] as int,
      soDienThoai: json['resultObj']['soDienThoai'] as String?,
      fax: json['resultObj']['fax'] as String?,
      email: json['resultObj']['email'] as String?,
      website: json['resultObj']['website'] as String?,
      hoTenNguoiDaiDien: json['resultObj']['hoTenNguoiDaiDien'] as String?,
      thoiDiemBatDauKinhDoanh:
          json['resultObj']['thoiDiemBatDauKinhDoanh'] as String?,
      gioDongCua: json['resultObj']['gioDongCua'] as String,
      gioMoCua: json['resultObj']['gioMoCua'] as String,
      toaDoX: (json['resultObj']['toaDoX'] as num).toDouble(),
      toaDoY: (json['resultObj']['toaDoY'] as num).toDouble(),
      banKinhQuyUoc: json['resultObj']['banKinhQuyUoc'] as int,
      ngayCVDatChuan: json['resultObj']['ngayCVDatChuan'] as String?,
      soCVDatChuan: json['resultObj']['soCVDatChuan'] as String?,
      nhaCungCapId: json['resultObj']['nhaCungCapId'] as int?,
      phucVu: json['resultObj']['phucVu'] as String?,
      maDoanhNghiep: json['resultObj']['maDoanhNghiep'] as String?,
      thuocHoChieu: json['resultObj']['thuocHoChieu'] as bool,
      childGetDiaDiemByMonAns:
          (json['resultObj']['childGetDiaDiemByMonAns'] as List)
              .map((e) => LocationDetail.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anhDaiDien': anhDaiDien,
      'soGiayPhep': soGiayPhep,
      'linhVucKinhDoanhId': linhVucKinhDoanhId,
      'hangSao': hangSao,
      'loaiHinhId': loaiHinhId,
      'dienTichMatBang': dienTichMatBang,
      'soTang': soTang,
      'soNha': soNha,
      'phuongXaId': phuongXaId,
      'quanHuyenId': quanHuyenId,
      'tinhThanhId': tinhThanhId,
      'soDienThoai': soDienThoai,
      'fax': fax,
      'email': email,
      'website': website,
      'hoTenNguoiDaiDien': hoTenNguoiDaiDien,
      'thoiDiemBatDauKinhDoanh': thoiDiemBatDauKinhDoanh,
      'gioDongCua': gioDongCua,
      'gioMoCua': gioMoCua,
      'toaDoX': toaDoX,
      'toaDoY': toaDoY,
      'banKinhQuyUoc': banKinhQuyUoc,
      'ngayCVDatChuan': ngayCVDatChuan,
      'soCVDatChuan': soCVDatChuan,
      'nhaCungCapId': nhaCungCapId,
      'phucVu': phucVu,
      'maDoanhNghiep': maDoanhNghiep,
      'thuocHoChieu': thuocHoChieu,
      'childGetDiaDiemByMonAns':
          childGetDiaDiemByMonAns.map((x) => x.toJson()).toList(),
    };
  }

  LocationDetail? getDetailByLanguage(int ngonNguID) {
    return childGetDiaDiemByMonAns.firstWhere(
      (detail) => detail.ngonNguID == ngonNguID,
      orElse: () => childGetDiaDiemByMonAns.first,
    );
  }

  factory LocationModel.fromLocationModel2(LocationModel2 model) {
    return LocationModel(
      id: model.quanAnID, // Sử dụng quanAnID làm id
      anhDaiDien: null,
      soGiayPhep: null,
      linhVucKinhDoanhId: null,
      hangSao: 0,
      loaiHinhId: null,
      dienTichMatBang: 0,
      soTang: 0,
      soNha: model.soNha,
      phuongXaId: 0,
      quanHuyenId: 0,
      tinhThanhId: 0,
      soDienThoai: null,
      fax: null,
      email: null,
      website: null,
      hoTenNguoiDaiDien: null,
      thoiDiemBatDauKinhDoanh: null,
      gioDongCua: '',
      gioMoCua: '',
      toaDoX: 0.0,
      toaDoY: 0.0,
      banKinhQuyUoc: 0,
      ngayCVDatChuan: null,
      soCVDatChuan: null,
      nhaCungCapId: null,
      phucVu: null,
      maDoanhNghiep: null,
      thuocHoChieu: false,
      childGetDiaDiemByMonAns: [
        LocationDetail(
          noiDungID: 0,
          ngonNguID: model.ngonNguID,
          tenDiaDiem: model.ten,
          duongPho: model.duongPho,
          ghiChu: null,
          tenVietTat: '',
          gioiThieu: '',
          tenLoai: '',
          moTa: '',
        ),
      ],
    );
  }
}

class LocationDetail {
  final int noiDungID;
  final int ngonNguID;
  final String tenDiaDiem;
  final String duongPho;
  final String? ghiChu;
  final String tenVietTat;
  final String gioiThieu;
  final String tenLoai;
  final String moTa;

  LocationDetail({
    required this.noiDungID,
    required this.ngonNguID,
    required this.tenDiaDiem,
    required this.duongPho,
    this.ghiChu,
    required this.tenVietTat,
    required this.gioiThieu,
    required this.tenLoai,
    required this.moTa,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> json) {
    return LocationDetail(
      noiDungID: json['noiDungID'] as int,
      ngonNguID: json['ngonNguID'] as int,
      tenDiaDiem: json['tenDiaDiem'] as String,
      duongPho: json['duongPho'] as String,
      ghiChu: json['ghiChu'] as String?,
      tenVietTat: json['tenVietTat'] as String,
      gioiThieu: json['gioiThieu'] as String,
      tenLoai: json['tenLoai'] as String,
      moTa: json['moTa'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noiDungID': noiDungID,
      'ngonNguID': ngonNguID,
      'tenDiaDiem': tenDiaDiem,
      'duongPho': duongPho,
      'ghiChu': ghiChu,
      'tenVietTat': tenVietTat,
      'gioiThieu': gioiThieu,
      'tenLoai': tenLoai,
      'moTa': moTa,
    };
  }
}
