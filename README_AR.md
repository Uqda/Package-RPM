# حزمة UQDA لأنظمة RPM

هذا هو مستودع الحزمة الرسمية لـ [UQDA Core](https://github.com/Uqda/Core) على
Fedora والأنظمة المتوافقة مع RPM. أول إصدار حزمة هو `0.1.4-1`: الرقم `0.1.4`
هو إصدار Core والرقم `1` هو مراجعة الحزمة.

يبني المشروع من أرشيف المصدر المضمّن بالتبعيات والمثبت ببصمة SHA-256، ويمنع
Go من تنزيل تبعيات أثناء بناء RPM. الحزمة الأساسية توفر `uqda` و`uqdactl`
و`uqda-latency` وخدمات systemd، بينما `uqda-gateway` حزمة اختيارية للبوابة.

## البناء على Fedora

```sh
sudo dnf install -y rpm-build rpmdevtools rpmlint golang systemd-rpm-macros curl
./tests/spec-static.sh
./scripts/build-rpm.sh
```

## التثبيت من Fedora COPR

```sh
sudo dnf install -y dnf5-plugins
sudo dnf copr enable maher-xs/uqda
sudo dnf install uqda
sudo systemctl enable --now uqda
sudo uqdactl doctor
```

ولإضافة أدوات البوابة الاختيارية:

```sh
sudo dnf install uqda-gateway
```

يُنشأ `/etc/uqda.conf` بصلاحية `0600`. لا تحذف الحزمة هذا الملف عند التحديث
أو الإزالة حتى لا تضيع هوية العقدة دون قصد.

بوابة `RPM Release Gate` تفحص ملف SPEC، وبصمة المصدر، والبناء، ومحتويات RPM،
والتثبيت وإعادة التثبيت والمحافظة على الهوية والإزالة قبل السماح بالإصدار.
