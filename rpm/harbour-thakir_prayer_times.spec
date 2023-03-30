# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       harbour-thakir_prayer_times

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    Provides Prayer times for Sailfish OS
Version:    4.0.29
Release:    1
Group:      Qt/Qt
License:    GPLv3
URL:        https://sites.google.com/site/thakirprayertimes/thakir-prayer-times-en
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-thakir_prayer_times.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   qt5-qtdeclarative-import-xmllistmodel
Requires:   nemo-qml-plugin-contextkit-qt5
BuildRequires:  pkgconfig(sailfishapp) >= 0.0.10
BuildRequires:  pkgconfig(Qt5Multimedia)
BuildRequires:  pkgconfig(Qt5Xml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(keepalive)
BuildRequires:  desktop-file-utils

%description
Thakir Prayer Times provides Prayer times for Sailfish OS.

# This description section includes metadata for SailfishOS:Chum, see
# https://github.com/sailfishos-chum/main/blob/main/Metadata.md
%if 0%{?_chum}
PackageName: Thakir Prayer Times
Type: desktop-application
DeveloperName: HAFIANE Mohamed
Categories:
 - Utility
Custom:
  Repo: https://github.com/hafmed/harbour-thakir_prayer_times
Icon: https://github.com/hafmed/harbour-thakir_prayer_times/blob/master/icon-thakir_sailfish_Quran_new.svg
Screenshots:
 - https://github.com/hafmed/harbour-thakir_prayer_times/blob/master/screenshots/Screenshot1.png
 - https://github.com/hafmed/harbour-thakir_prayer_times/blob/master/screenshots/Screenshot2.png
 - https://github.com/hafmed/harbour-thakir_prayer_times/blob/master/screenshots/Screenshot3.png
Url:
  Homepage: https://github.com/hafmed/harbour-thakir_prayer_times
  #Help: https://github.com/piggz/harbour-advanced-camera/discussions
  Bugtracker: https://github.com/hafmed/harbour-thakir_prayer_times/issues
  #Donation: https://www.paypal.me/piggz
%endif

%changelog
 - Minor SFOS 4.5 fixes

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5  \
    VERSION=%{version}

%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%defattr(644,root,root,755)
%attr(755,root,root) %{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor
%{_datadir}/%{name}/translations
%{_datadir}/%{name}/qml
%{_datadir}/%{name}/sounds
%{_bindir}/%{name}
# >> files
# << files
