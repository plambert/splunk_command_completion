function fSplunkComplete() {
  local wordCur=${COMP_WORDS[COMP_CWORD]}
  local wordPrev=${COMP_WORDS[COMP_CWORD-1]}
  case "$wordPrev" in
    splunk           ) mapfile -t COMPREPLY < <(compgen -W "add apply backup bootstrap bucket-maint check clear commands disable display edit enable export get-base-dirname import init install list package rebalance reload remove restore resync rollback rolling-restart rotate set set-base-dirname show test totalcount transfer upgrade upgrade-finalize upgrade-init validate help ftr start startnoss stop restart restartss status rebuild train fsck clean-dispatch clean-srtemp validate verifyconfig anonymize find clean createssl juststopit migrate --version -version version httpport soapport spool ftw envvars _RAW_envvars _port_check cmd _rest_xml_dump search dispatch rtsearch livetail _normalizepath _internal logout btool pooling _web_bootstart offline clone-prep-clear-config diag" -- "$wordCur") ;;
    _internal        ) mapfile -t COMPREPLY < <(compgen -W "http mgmt https pre-flight-checks check-db call rpc rpc-auth soap-call soap-call-auth prefixcount totalcount check-xml-files first-time-run make-splunkweb-certs-and-var-run-merged" -- "$wordCur") ;;
    clean            ) mapfile -t COMPREPLY < <(compgen -W "all eventdata globaldata userdata inputdata locks deployment artifacts raft" -- "$wordCur") ;;
    fsck             ) mapfile -t COMPREPLY < <(compgen -W "scan repair clear-bloomfilter make-searchable" -- "$wordCur") ;;
    migrate          ) mapfile -t COMPREPLY < <(compgen -W "input-records to-modular-inputs rename-cluster-app" -- "$wordCur") ;;
    help             ) mapfile -t COMPREPLY < <(compgen -W "add files alert alerts anonymize auth blacklist boot-start clean client clone-prep-clear-config cloning cluster clustering command name createssl data datastore deploy-client deploy-clients deploy-poll deploy-server deployment deployments deploypoll deployserver dir directory dispatch dist-search distributed distributed-search event eventdata exec export extract fields fifo file find forward-server forwarding forwardserver global globaldata help import input inputs live-tail livetail local local-index login login logout logs modifier modifiers offline operators parameter parameters path pathname poll port ports real-time realtime routing rtsearch saved-search savedsearch scripted search search command search commands search fields search modifier search modifiers search-commands search-field search-fields search-help search-modifier search-modifiers search-operators search-server searches searching searchserver server server-status shcluster shclustering splunk splunk-version spool spool status store tools uri userdata validate version watch" -- "$wordCur") ;;
    cmd              ) mapfile -t COMPREPLY < <(compgen -o default -o filenames -G '/usr/local/splunk/bin/*' -- "$wordCur") ;;
    add              ) mapfile -t COMPREPLY < <(compgen -W "blacklist exec fifo forward-server index indexer-discovery license licenser-pools licensing master oneshot role scripted shcluster-member tail tcp udp user watch workload-pool workload-rule" -- "$wordCur") ;;
    apply            ) mapfile -t COMPREPLY < <(compgen -W "cluster-bundle shcluster-bundle" -- "$wordCur") ;;
    backup           ) mapfile -t COMPREPLY < <(compgen -W "kvstore" -- "$wordCur") ;;
    bootstrap        ) mapfile -t COMPREPLY < <(compgen -W "shcluster-captain" -- "$wordCur") ;;
    bucket-maint     ) mapfile -t COMPREPLY < <(compgen -W "rebuild-bucket-manifests rebuild-metadata rebuild-metadata-and-manifests roll-hot-buckets" -- "$wordCur") ;;
    check            ) mapfile -t COMPREPLY < <(compgen -W "workload-config" -- "$wordCur") ;;
    clear            ) mapfile -t COMPREPLY < <(compgen -W "shcluster-scheduler-cache" -- "$wordCur") ;;
    commands         ) mapfile -t COMPREPLY < <(compgen -W "cheatsheet" -- "$wordCur") ;;
    disable          ) mapfile -t COMPREPLY < <(compgen -W "ad app boot-start bundle client deploy-server dist-search eventlogs index listen maintenance-mode module monitornohandle perfmon regmon scheduler serverclass shcluster-config shcluster-maintenance-mode web-ssl webserver winhostmon winnetmon winprintmon wmi workload-management" -- "$wordCur") ;;
    display          ) mapfile -t COMPREPLY < <(compgen -W "app client deploy-server dist-search listen module serverclass web-ssl webserver" -- "$wordCur") ;;
    edit             ) mapfile -t COMPREPLY < <(compgen -W "cluster-config exec fifo index indexer-discovery licenser-groups licenser-localslave licenser-pools licensing master role s2s scripted shcluster-common-encrypt shcluster-config tail tcp udp user watch workload-category workload-pool workload-rule" -- "$wordCur") ;;
    enable           ) mapfile -t COMPREPLY < <(compgen -W "ad app boot-start bundle client deploy-server dist-search eventlogs index listen maintenance-mode module monitornohandle perfmon regmon scheduler serverclass shcluster-maintenance-mode web-ssl webserver winhostmon winnetmon winprintmon wmi workload-management" -- "$wordCur") ;;
    export           ) mapfile -t COMPREPLY < <(compgen -W "globaldata" -- "$wordCur") ;;
    get-base-dirname ) mapfile -t COMPREPLY < <(compgen -W "workload-config" -- "$wordCur") ;;
    import           ) mapfile -t COMPREPLY < <(compgen -W "globaldata" -- "$wordCur") ;;
    init             ) mapfile -t COMPREPLY < <(compgen -W "shcluster-config" -- "$wordCur") ;;
    install          ) mapfile -t COMPREPLY < <(compgen -W "app bundle" -- "$wordCur") ;;
    list             ) mapfile -t COMPREPLY < <(compgen -W "ad app appserver-ports auth-roles blacklist bundle client cluster-buckets cluster-config cluster-generation cluster-peers config datastore-dir default-hostname deploy-info deploypoll dfsmaster-port eventlogs excess-buckets exec fifo fips-mode forward-server guid health index indexer-discovery inputstatus kvstore-port license licenser-groups licenser-localslave licenser-messages licenser-pools licenser-slaves licenser-stack licensing log-level master master-info minfreemb monitornohandle peer-buckets peer-info perfmon regmon role scripted servername shcluster-artifacts shcluster-bundle shcluster-captain-info shcluster-config shcluster-configuration-set shcluster-member-artifacts shcluster-member-info shcluster-members shcluster-scheduler-jobs splunkd-port tail tcp udp user watch web-port winhostmon winnetmon winprintmon wmi workload-category workload-pool workload-rule" -- "$wordCur") ;;
    package          ) mapfile -t COMPREPLY < <(compgen -W "bundle" -- "$wordCur") ;;
    rebalance        ) mapfile -t COMPREPLY < <(compgen -W "cluster-data" -- "$wordCur") ;;
    reload           ) mapfile -t COMPREPLY < <(compgen -W "ad crl deploy-server exec index listen perfmon regmon serverclass tail tcp udp wmi" -- "$wordCur") ;;
    remove           ) mapfile -t COMPREPLY < <(compgen -W "app blacklist bundle cluster-peers excess-buckets exec fifo forward-server index indexer-discovery license licenser-pools licensing master role scripted shcluster-member tail tcp udp user watch workload-pool workload-rule" -- "$wordCur") ;;
    restore          ) mapfile -t COMPREPLY < <(compgen -W "kvstore" -- "$wordCur") ;;
    resync           ) mapfile -t COMPREPLY < <(compgen -W "kvstore shcluster-replicated-config" -- "$wordCur") ;;
    rollback         ) mapfile -t COMPREPLY < <(compgen -W "cluster-bundle" -- "$wordCur") ;;
    rolling-restart  ) mapfile -t COMPREPLY < <(compgen -W "cluster-peers shcluster-members" -- "$wordCur") ;;
    rotate           ) mapfile -t COMPREPLY < <(compgen -W "shcluster-splunk-secret splunk-secret" -- "$wordCur") ;;
    set              ) mapfile -t COMPREPLY < <(compgen -W "appserver-ports datastore-dir default-hostname deploypoll dfsmaster-port indexing-ready kvstore-port log-level minfreemb server-type servername shcluster-indexing-ready splunkd-port web-port" -- "$wordCur") ;;
    set-base-dirname ) mapfile -t COMPREPLY < <(compgen -W "workload-config" -- "$wordCur") ;;
    show             ) mapfile -t COMPREPLY < <(compgen -W "appserver-ports cluster-bundle-status cluster-status config datastore-dir default-hostname deploypoll dfsmaster-port fips-mode guid health kvstore-port kvstore-status license log-level maintenance-mode minfreemb scheduler-status servername shcluster-maintenance-mode shcluster-status splunkd-port web-port workload-management-status" -- "$wordCur") ;;
    test             ) mapfile -t COMPREPLY < <(compgen -W "system" -- "$wordCur") ;;
    totalcount       ) mapfile -t COMPREPLY < <(compgen -W "prefixcount" -- "$wordCur") ;;
    transfer         ) mapfile -t COMPREPLY < <(compgen -W "shcluster-captain" -- "$wordCur") ;;
    upgrade          ) mapfile -t COMPREPLY < <(compgen -W "bundle" -- "$wordCur") ;;
    upgrade-finalize ) mapfile -t COMPREPLY < <(compgen -W "cluster-peers shcluster-members" -- "$wordCur") ;;
    upgrade-init     ) mapfile -t COMPREPLY < <(compgen -W "cluster-peers shcluster-members" -- "$wordCur") ;;
    validate         ) mapfile -t COMPREPLY < <(compgen -W "cluster-bundle" -- "$wordCur") ;;
    *                ) mapfile -t COMPREPLY < <(compgen -f -- "$wordCur") ;;
  esac
}
complete -r splunk 2>/dev/null
complete -F fSplunkComplete splunk
