# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic linux-info multilib systemd user \
	meson xdg-utils git-r3

DESCRIPTION="The Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org https://github.com/MusicPlayerDaemon/MPD"
EGIT_REPO_URI="https://github.com/MusicPlayerDaemon/MPD.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="adplug +alsa ao audiofile bzip2 cdio +curl debug +eventfd expat faad
	+fifo +ffmpeg flac fluidsynth gme +icu +id3tag +inotify +ipv6 jack
	lame mms libav libmpdclient libsamplerate libsoxr +mad mikmod modplug
	mpg123 musepack +network nfs ogg openal opus oss pipe pulseaudio recorder
	samba selinux sid +signalfd sndfile soundcloud sqlite systemd twolame
	unicode upnp vorbis wavpack wildmidi zeroconf zip zlib webdav"

OUTPUT_PLUGINS="alsa ao fifo jack network openal oss pipe pulseaudio recorder"
DECODER_PLUGINS="adplug audiofile faad ffmpeg flac fluidsynth mad mikmod
	modplug mpg123 musepack ogg flac sid vorbis wavpack wildmidi"
ENCODER_PLUGINS="audiofile flac lame twolame vorbis"

REQUIRED_USE="
	|| ( ${OUTPUT_PLUGINS} )
	|| ( ${DECODER_PLUGINS} )
	network? ( || ( ${ENCODER_PLUGINS} ) )
	recorder? ( || ( ${ENCODER_PLUGINS} ) )
	opus? ( ogg )
	upnp? ( expat )
	webdav? ( curl expat )"

CDEPEND="!<sys-cluster/mpich2-1.4_rc2
	adplug? ( media-libs/adplug )
	alsa? (
		media-sound/alsa-utils
		media-libs/alsa-lib
	)
	ao? ( media-libs/libao[alsa?,pulseaudio?] )
	audiofile? ( media-libs/audiofile )
	bzip2? ( app-arch/bzip2 )
	cdio? ( dev-libs/libcdio-paranoia )
	curl? ( net-misc/curl )
	expat? ( dev-libs/expat )
	faad? ( media-libs/faad2 )
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	flac? ( media-libs/flac[ogg?] )
	fluidsynth? ( media-sound/fluidsynth )
	gme? ( >=media-libs/game-music-emu-0.6.0_pre20120802 )
	icu? ( dev-libs/icu:= )
	id3tag? ( media-libs/libid3tag )
	jack? ( virtual/jack )
	lame? ( network? ( media-sound/lame ) )
	libmpdclient? ( media-libs/libmpdclient )
	libsamplerate? ( media-libs/libsamplerate )
	libsoxr? ( media-libs/soxr )
	mad? ( media-libs/libmad )
	mikmod? ( media-libs/libmikmod:0 )
	mms? ( media-libs/libmms )
	modplug? ( media-libs/libmodplug )
	mpg123? ( >=media-sound/mpg123-1.12.2 )
	musepack? ( media-sound/musepack-tools )
	network? (
		>=media-libs/libshout-2
		!lame? ( !vorbis? ( media-libs/libvorbis ) )
	)
	nfs? ( net-fs/libnfs )
	ogg? ( media-libs/libogg )
	openal? ( media-libs/openal )
	opus? ( media-libs/opus )
	pulseaudio? ( media-sound/pulseaudio )
	samba? ( >=net-fs/samba-4.0.25 )
	sid? ( || ( media-libs/libsidplay:2 media-libs/libsidplayfp ) )
	sndfile? ( media-libs/libsndfile )
	soundcloud? ( >=dev-libs/yajl-2:= )
	sqlite? ( dev-db/sqlite:3 )
	systemd? ( sys-apps/systemd )
	twolame? ( media-sound/twolame )
	upnp? ( net-libs/libupnp:= )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
	wildmidi? ( media-sound/wildmidi )
	zeroconf? ( net-dns/avahi[dbus] )
	zip? ( dev-libs/zziplib )
	zlib? ( sys-libs/zlib )"
DEPEND="${CDEPEND}
	dev-libs/boost
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-mpd )
"

meson_enable() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

pkg_setup() {
	use network || ewarn "Icecast and Shoutcast streaming needs networking."
	use fluidsynth && ewarn "Using fluidsynth is discouraged by upstream."

	enewuser mpd "" "" "/var/lib/mpd" audio

	if use eventfd; then
		CONFIG_CHECK+=" ~EVENTFD"
		ERROR_EVENTFD="${P} requires eventfd in-kernel support."
	fi
	if use signalfd; then
		CONFIG_CHECK+=" ~SIGNALFD"
		ERROR_SIGNALFD="${P} requires signalfd in-kernel support."
	fi
	if use inotify; then
		CONFIG_CHECK="~INOTIFY_USER"
		ERROR_INOTIFY_USER="${P} requires inotify in-kernel support."
	fi
	if use eventfd || use signalfd || use inotify; then
		linux-info_pkg_setup
	fi

	elog "If you will be starting mpd via /etc/init.d/mpd, please make
		sure that MPD's pid_file is _set_."
}

src_prepare() {
	cp -f doc/mpdconf.example doc/mpdconf.dist || die "cp failed"
	default
}

src_configure() {
	local emesonargs=(
		-Ddatabase=true
		-Ddocumentation=false
		-Ddsd=true
		-Dshine=disabled
		-Dsolaris_output=disabled
		-Dtcp=true
	)

	if use network; then
		emesonargs+=(
			-Dshout=enabled
			$(meson_enable vorbis vorbisenc)
			-Dhttpd=true
			$(meson_enable lame)
			$(meson_enable twolame)
			$(meson_use audiofile wave_encoder)
		)
	else
		emesonargs+=(
			-Dshout=disabled
			-Dvorbisenc=disabled
			-Dhttpd=false
			-Dlame=disabled
			-Dtwolame=disabled
			-Dwave_encoder=false
		)
	fi

	if use samba || use upnp; then
		emesonargs+=( -Dneighbor=true )
	else
		emesonargs+=( -Dneighbor=false )
	fi

	append-lfs-flags
	append-ldflags "-L/usr/$(get_libdir)/sidplay/builders"

	emesonargs+=(
		$(meson_use eventfd)
		$(meson_use signalfd)
		$(meson_enable libmpdclient)
		$(meson_enable expat)
		$(meson_enable upnp)
		$(meson_enable adplug)
		$(meson_enable alsa)
		$(meson_enable ao)
		$(meson_enable audiofile)
		$(meson_enable zlib)
		$(meson_enable bzip2)
		$(meson_enable cdio cdio_paranoia)
		$(meson_enable curl)
		$(meson_enable samba smbclient)
		$(meson_enable nfs)
		$(usex debug --buildtype=debug --buildtype=plain)
		$(meson_enable ffmpeg)
		$(meson_use fifo)
		$(meson_enable flac)
		$(meson_enable fluidsynth)
		$(meson_enable gme)
		$(meson_enable id3tag)
		$(meson_use inotify)
		$(meson_enable ipv6)
		$(meson_enable cdio iso9660)
		$(meson_enable jack)
		$(meson_enable soundcloud)
		$(meson_enable libsamplerate)
		$(meson_enable libsoxr soxr)
		$(meson_enable mad)
		$(meson_enable mikmod)
		$(meson_enable mms)
		$(meson_enable modplug)
		$(meson_enable musepack mpcdec)
		$(meson_enable mpg123)
		$(meson_enable openal)
		$(meson_enable opus)
		$(meson_enable oss)
		$(meson_use pipe pipe)
		$(meson_enable pulseaudio pulse)
		$(meson_use recorder)
		$(meson_enable sid sidplay)
		$(meson_enable sndfile)
		$(meson_enable sqlite)
		$(meson_enable systemd)
		$(meson_enable vorbis)
		$(meson_enable wavpack)
		$(meson_enable wildmidi)
		$(meson_enable zip zzip)
		$(meson_enable icu)
		$(meson_enable webdav)
		$(meson_enable faad)
		$(usex zeroconf -Dzeroconf=avahi -Dzeroconf=disabled)
		-Dsystemd_system_unit_dir=$(systemd_get_systemunitdir)
		-Dsystemd_user_unit_dir=$(systemd_get_userunitdir)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
	meson_src_install

	insinto /etc
	newins doc/mpdconf.dist mpd.conf

	newinitd "${FILESDIR}"/mpd.init mpd

	if use unicode; then
		sed -i -e 's:^#filesystem_charset.*$:filesystem_charset "UTF-8":' \
			"${ED}"/etc/mpd.conf || die "sed failed"
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	use prefix || diropts -m0755 -o mpd -g audio
	dodir /var/lib/mpd
	keepdir /var/lib/mpd
	dodir /var/lib/mpd/music
	keepdir /var/lib/mpd/music
	dodir /var/lib/mpd/playlists
	keepdir /var/lib/mpd/playlists
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
