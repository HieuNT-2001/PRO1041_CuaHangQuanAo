package entity;

public class HoaDonChiTiet {

    private int id;
    private int maHD;
    private int maSP;
    private int soLuong;

    public HoaDonChiTiet() {
    }

    public HoaDonChiTiet(int id, int maHD, int maSP, int soLuong) {
        this.id = id;
        this.maHD = maHD;
        this.maSP = maSP;
        this.soLuong = soLuong;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMaHD() {
        return maHD;
    }

    public void setMaHD(int maHD) {
        this.maHD = maHD;
    }

    public int getMaSP() {
        return maSP;
    }

    public void setMaSP(int maSP) {
        this.maSP = maSP;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

}
