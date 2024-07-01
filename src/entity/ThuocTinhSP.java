package entity;

public class ThuocTinhSP {

    private int maThuocTinh;
    private String tenThuocTinh;
    private String giaTri;

    public ThuocTinhSP() {
    }

    public ThuocTinhSP(int maThuocTinh, String tenThuocTinh, String giaTri) {
        this.maThuocTinh = maThuocTinh;
        this.tenThuocTinh = tenThuocTinh;
        this.giaTri = giaTri;
    }

    public int getMaThuocTinh() {
        return maThuocTinh;
    }

    public void setMaThuocTinh(int maThuocTinh) {
        this.maThuocTinh = maThuocTinh;
    }

    public String getTenThuocTinh() {
        return tenThuocTinh;
    }

    public void setTenThuocTinh(String tenThuocTinh) {
        this.tenThuocTinh = tenThuocTinh;
    }

    public String getGiaTri() {
        return giaTri;
    }

    public void setGiaTri(String giaTri) {
        this.giaTri = giaTri;
    }

}
