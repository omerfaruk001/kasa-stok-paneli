# Claude'a verilecek komut — Gelir & Gider Paneli

Aşağıdaki metni olduğu gibi Claude'a yapıştırabilirsiniz.

---

Bir yemek/büfe işletmesi için **gelir ve gider takibi ile kâr hesaplaması** yapan, modern arayüzlü, pratik ve kompakt bir **yönetim paneli** yap.

## Teknik
- Tek bir `index.html` dosyası olsun (HTML + CSS + JavaScript içinde). Kurulum gerektirmesin, çift tıklayınca tarayıcıda açılsın, internet olmadan çalışsın.
- Veriler tarayıcının `localStorage` alanında saklansın.
- Arayüz tamamen Türkçe olsun. Para birimi ₺, Türk formatında gösterilsin (₺1.250,50). Tarihler GG.AA.YYYY olsun.
- Tutar alanlarına hem `1250,50` hem `1.250,50` hem `1250.5` yazılabilsin ve doğru okunsun.
- Masaüstünde sol menü, telefonda alt menü olacak şekilde mobil uyumlu olsun. Açık/koyu tema düğmesi olsun.

## Giriş
- Açılışta yönetici şifre ekranı olsun. **Şifre: 001002**
- Yanlış şifrede uyarı versin. Sağ üstte çıkış düğmesi olsun.

## Dönem seçici (üst bar)
Bugün / Bu Hafta / Bu Ay / Geçen Ay / Bu Yıl / Tüm Zamanlar / Özel Aralık. Tüm sayfalar seçili döneme göre hesaplasın.

## 1) Panel (ana sayfa)
- Kartlar: Toplam Gelir, Toplam Gider, **Net Kâr**, Kâr Marjı (%).
- Günlük gelir–gider sütun grafiği (uzun dönemlerde aylık).
- Ödeme şekline göre gelir dağılımı (Nakit / POS / Havale), en büyük 8 gider kalemi.
- Gider grupları (malzeme / sabit / diğer) ve son işlemler.
- Hızlı düğmeler: Gelir Gir, Gider Gir, Raporlar.

## 2) Gelirler
- Gelir 3 şekilde geliyor: **Nakit**, **POS cihazı (kart)**, **Banka havalesi / EFT**.
- Gün sonu formu: tarih + nakit + POS + havale + not alanları tek formda. Boş bırakılan alan kaydedilmesin.
- Liste: tarih, ödeme şekli (renkli etiket), not, tutar, sil düğmesi ve toplam.

## 3) Giderler
Hazır gider kalemleri 3 grupta olsun:
- **Malzemeler**: Kola / Su / Meyve Suyu, Sucuk, Kaşar, Et, Tavuk, Margarin, Salam, Patates, Ketçap / Mayonez, Sebze
- **Sabit giderler**: Kira, Elektrik, Doğalgaz, Su Faturası, Personel Maaşı, İnternet / Telefon
- **Diğer giderler**: Ekmek, Ambalaj / Sarf Malzeme, Temizlik, Bakım / Onarım, Diğer

Form: tarih, gider kalemi, tutar, ödeme şekli (nakit / kart / havale), açıklama veya tedarikçi.
- **Stok takibi olmayacak.** Malzemeler sadece gider kalemi olarak girilir; miktar veya stok alanı olmasın.
- Liste kaleme göre filtrelenebilsin, grup toplamları kart olarak gösterilsin.

## 4) Raporlar (detaylı)
- Dönem özeti: nakit, POS, havale, brüt gelir, malzeme alımları, sabit ve diğer giderler, POS komisyonu, toplam gider, **net kâr**, kâr marjı, satış yapılan gün sayısı, günlük ortalama gelir ve gider.
- Gider kalemleri tablosu: kayıt sayısı, tutar ve yüzde payı.
- Son 12 ayın aylık karşılaştırması: nakit, POS, havale, gelir, gider, kâr, marj.
- Günlük döküm tablosu.
- **Yazdır / PDF** düğmesi (yazdırırken menüler ve formlar gizlensin) ve **Excel (CSV) indir** düğmesi (noktalı virgülle ayrılmış, Türkçe karakterler bozulmadan).

## 5) Ayarlar
- İşletme adı, POS komisyon oranı (%): girilirse kart tahsilatından düşülerek net kâr hesaplansın.
- Yeni gider kalemi ekleme (grup seçerek) ve ad düzenleme. Kaydı olan kalem silinemesin.
- **Yedek al (JSON indir)**, **yedekten yükle**, tüm verileri sil (çift onaylı).

## Hesaplama
- Net Kâr = Toplam Gelir − Toplam Gider − POS Komisyonu
- Kâr Marjı = Net Kâr ÷ Toplam Gelir × 100

## Tasarım
Sade, modern ve kompakt bir yönetim paneli: kart yapısı, ince kenarlıklar, gelir yeşil, gider kırmızı, net kâr artıdaysa yeşil eksideyse kırmızı. Her silme işleminde onay istesin. Kayıttan sonra kısa bir bildirim göstersin.
