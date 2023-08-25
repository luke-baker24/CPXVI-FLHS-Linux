#Function taken from https://askubuntu.com/questions/313483/how-do-i-change-firefoxs-aboutconfig-from-a-shell-script
ff_set()
{
    sed -i 's/user_pref("'$1'",.*);/user_pref("'$1'",'$2');/' prefs.js
    grep -q "\"$1\"," prefs.js || echo "user_pref(\"$1\",$2);" >> prefs.js
}

#Configured according to the CIS Benchmarks for Firefox
#Note: Ignoring 1.5, 3.1

#sudo touch /usr/lib/firefox/defaults/pref/local-settings.js

#ff_set general.config.obscure_value '0'
#ff_set general.config.filename 'mozilla.cfg'

#NOTE: set settings on local-settings.js so it is immutable by non-admins

#sudo touch /usr/lib/firefox/mozilla.cfg
#echo '//' | sudo tee -a /usr/lib/firefox/mozilla.cfg

#NOTE: set settings on mozilla.cfg so it is immutable by non-admins

xdg-settings set default-web-browser firefox.desktop

olddir=$(pwd)

cd $olddir/../../../../.mozilla/firefox/*.default-release/

touch prefs.js

ff_set app.update.enabled.remote.block_dangerous 'true'
ff_set app.update.auto 'true'
ff_set app.update.staging.enabled 'true'
ff_set app.update.interval '43200'
ff_set app.update.promptWaitTime '172800'
ff_set app.update.silent 'false'

ff_set plugins.update.notifyUser 'true'
ff_set plugins.hide_infobar_for_outdated_plugin 'false'

ff_set browser.search.update 'true'
ff_set browser.ssl_override_behavior '0'
ff_set browser.urlbar.filter.javascript 'true'
ff_set browser.helperApps.alwaysAsk.force 'true'
ff_set browser.download.manager.scanWhenDone 'true'
ff_set browser.safebrowsing.enabled 'true'
ff_set browser.safebrowsing.malware.enabled 'true'

ff_set network.http.sendSecureXSiteReferrer 'false'
ff_set network.auth.force-generic-ntlm-v1 'false'
ff_set network.http.phishy-userpass-length '1'
ff_set network.IDN_show_punycode 'true'
ff_set network.cookie.cookieBehavior '1'
ff_set network.protocol-handler.warn-external-default 'true'
ff_set network.jar.open-unsafe-types 'false'

ff_set security.fileuri.strict_origin_policy 'true'
ff_set security.tls.version.max '3'
ff_set security.tls.version.min '1'
ff_set security.OCSP.enabled '1'
ff_set security.mixed_content.block_active_content 'true'
ff_set security.ocsp.require 'true'
ff_set security.xpconnect.plugin.unrestricted 'false'
ff_set security.dialog_enable_delay '2000'

ff_set services.sync.enabled 'false'

ff_set media.peerconnection.enabled 'false'
ff_set media.peerconnection.use_document_iceservers 'false'

ff_set dom.disable_window_status_change 'true'
ff_set dom.disable_window_open_feature.location 'true'
ff_set dom.disable_window_open_feature.status 'true'
ff_set dom.allow_scripts_to_close_windows 'false'

ff_set privacy.popups.policy '1'
ff_set privacy.donottrackheader.enabled 'true'
ff_set privacy.donottrackheader.value '1'
ff_set privacy.trackingprotection.enabled 'true'
ff_set privacy.trackingprotection.pbmode 'true'
ff_set privacy.popups.disable_from_plugins '2'

ff_set signon.rememberSignons 'false'

ff_set geo.enabled 'false'

ff_set xpinstall.whitelist.required 'true'

ff_set extensions.blocklist.enabled 'true'
ff_set extensions.blocklist.interval '86400'
ff_set extensions.update.autoUpdateDefault 'true'
ff_set extensions.update.enabled 'true'
ff_set extensions.update.interval '86400'

#Configured according to no standards, just regular hardening (does stuff in addition to CIS)

#Block dangerous downloads
ff_set browser.safebrowsing.downloads.remote.block_dangerous 'true'
ff_set browser.safebrowsing.downloads.remote.block_dangerous_host 'true'
ff_set browser.safebrowsing.downloads.remote.block_potentially_unwanted 'true'
ff_set browser.safebrowsing.downloads.remote.block_uncommon 'true'
ff_set browser.safebrowsing.phishing.enabled 'true'

#Enable HTTPS-Only Mode
ff_set dom.security.https_only_mode 'true'
ff_set dom.security.https_only_mode_ever_enabled 'true'

#Disable sending data to Mozilla
ff_set datareporting.healthreport.uploadEnabled 'false'
ff_set datareporting.policy.dataSubmissionPolicyAcceptedVersion '2'

ff_set app.shield.optoutstudies.enabled 'false'

ff_set browser.crashReports.unsubmittedCheck.autoSubmit2 'false'

#Blocking pop-up windows
ff_set dom.disable_open_during_load 'true'

#Strict content blocking
ff_set browser.contentblocking.category 'strict'

cd $olddir
