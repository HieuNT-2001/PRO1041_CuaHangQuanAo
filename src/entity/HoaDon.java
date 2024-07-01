package entity;

import java.util.Date;

public class HoaDon {

    private int maHD;
    private int maNV;
    private int maKH;
    private String maKM;
    private boolean kenhBanHang;
    private Date ngayTao;
    private boolean trangThai;
    private String lyDo;

    public HoaDon() {
    }

    public HoaDon(int maHD, int maNV, int maKH, String maKM, boolean kenhBanHang, Date ngayTao, boolean trangThai, String lyDo) {
        this.maHD = maHD;
        this.maNV = maNV;
        this.maKH = maKH;
        this.maKM = maKM;
        this.kenhBanHang = kenhBanHang;
        this.ngayTao = ngayTao;
        this.trangThai = trangThai;
        this.lyDo = lyDo;
    }

    public int getMaHD() {
        return maHD;
    }

    public void setMaHD(int maHD) {
        this.maHD = maHD;
    }

    public int getMaNV() {
        return maNV;
    }

    public void setMaNV(int maNV) {
        this.maNV = maNV;
    }

    public int getMaKH() {
        return maKH;
    }

    public void setMaKH(int maKH) {
        this.maKH = maKH;
    }

    public String getMaKM() {
        return maKM;
    }

    public void setMaKM(String maKM) {
        this.maKM = maKM;
    }

    public boolean isKenhBanHang() {
        return kenhBanHang;
    }

    public void setKenhBanHang(boolean kenhBanHang) {
        this.kenhBanHang = kenhBanHang;
    }

    public Date getNgayTao() {
        return ngayTao;
    }

    public void setNgayTao(Date ngayTao) {
        this.ngayTao = ngayTao;
    }

    public boolean isTrangThai() {
        return trangThai;
    }

    public void setTrangThai(boolean trangThai) {
        this.trangThai = trangThai;
    }

    public String getLyDo() {
        return lyDo;
    }

    public void setLyDo(String lyDo) {
        this.lyDo = lyDo;
    }

}
