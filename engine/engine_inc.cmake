set(CMAKE_MODULE_PATH ${SRCDIR}/cmake)
set(OUTBINNAME "engine_client")
set(OUTBINDIR ${SRCDIR}/../game/bin)
message(STATUS "Engine SrcDir: ${ESRCDIR}")
set(GENERATED_PROTO_DIR "${ESRCDIR}/generated_proto")

include(${CMAKE_MODULE_PATH}/detect_platform.cmake)
include(${CMAKE_MODULE_PATH}/source_dll_base.cmake)
include(${CMAKE_MODULE_PATH}/protobuf_builder.cmake)

#TargetBuildAndAddProtosInFolder( ${OUTBINNAME} ${SRCDIR}/common ${ESRCDIR}/${GENERATED_PROTO_DIR} )
TargetBuildAndAddProto( ${OUTBINNAME} "${SRCDIR}/common/engine_gcmessages.proto" "${GENERATED_PROTO_DIR}" )
TargetBuildAndAddProto( ${OUTBINNAME} "${SRCDIR}/common/netmessages.proto" "${GENERATED_PROTO_DIR}" )
TargetBuildAndAddProto( ${OUTBINNAME} "${SRCDIR}/common/network_connection.proto" "${GENERATED_PROTO_DIR}" )

include_directories(${ESRCDIR})
include_directories(${ESRCDIR}/audio)
include_directories(${ESRCDIR}/audio/private)
include_directories(${ESRCDIR}/audio/private/snd_op_sys)
include_directories(${ESRCDIR}/audio/public)
include_directories(${SRCDIR}/thirdparty/quickhull)
include_directories(${SRCDIR}/external/crypto++-5.61)
if( WINDOWS )
    include_directories(${SRCDIR}/dx9sdk/include)
endif()

add_definitions(-DEXTRADEFINES -DUSE_CONVARS -DVOICE_OVER_IP -DBUMPMAP -D__USEA3D -D_ADD_EAX_ -DENGINE_DLL -DVERSION_SAFE_STEAM_API_INTERFACES -DPROTECTED_THINGS_ENABLE -DUSE_BREAKPAD_HANDLER)
if( NOT POSIX AND NOT PS3 )
    add_definitions(-Dfopen=dont_use_fopen)
endif()

if( DEDICATED )
    add_definitions(-DDEDICATED -DSWDS -DNO_BINK)
else()
    if( USE_SCALEFORM )
        add_definitions(-DINCLUDE_SCALEFORM)
    elseif( USE_ROCKETUI )
        add_definitions(-DINCLUDE_ROCKETUI)
    endif()
endif()
remove_definitions(-DBASE) #used by cryptopp REEE
add_definitions(-DALLOW_TEXT_MODE=1)

if( WINDOWS )
    #		$AdditionalDependencies			"$BASE dinput8.lib winmm.lib wsock32.lib ws2_32.lib wininet.lib vfw32.lib Rpcrt4.lib Iphlpapi.lib imm32.lib" [$WINDOWS]
    #		$AdditionalLibraryDirectories	"$BASE;${SRCDIR}\lib\common\vc7;${SRCDIR}\dx9sdk\lib" [$WINDOWS]
    #  		$AdditionalOptions				"$BASE /nodefaultlib:msvcrt.lib" [$WINDOWS]
endif()
if( LINUXALL AND (NOT DEDICATED) )
    target_link_libraries(${OUTBINNAME} SDL2 rt openal)
endif()
if( LINUXALL )
    target_link_options(${OUTBINNAME} PRIVATE -L/usr/lib32 -L/usr/lib)
    target_compile_options(${OUTBINNAME} PRIVATE -Wno-narrowing -fpermissive) #downgrade some errors to fix build
endif()

if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_rcon.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/rpt_engine.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_steamauth.cpp")
endif()

target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/clientframe.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/decal_clip.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/demofile.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/demostreamhttp.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/demostream.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/demobuffer.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/DevShotGenerator.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/OcclusionSystem.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/tmessage.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/r_efx.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/view.cpp")
endif()

target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/game/shared/cstrike15/dlchelper.h")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/baseclientstate.cpp")
if( NOT DEDICATED)
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cbenchmark.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cdll_engine_int.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_main.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demo.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_broadcast.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demoaction.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demoaction_types.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demoactioneditors.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demoactionmanager.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demoeditorpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demosmootherpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_demouipanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_foguipanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_txviewpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_entityreport.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_ents_parse.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_localnetworkbackdoor.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_parse_event.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_pluginhelpers.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_pred.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_splitscreen.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_texturelistpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/client.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/colorcorrectionpanel.cpp")
else()
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_null.cpp")
endif()

target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/console.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/buildcubemaps.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/buildmodelforworld.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/debug_leafvis.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/debugoverlay.cpp")
endif()


target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/decals.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/disp.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/disp_interface.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/disp_mapload.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_draw.cpp"	)
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_rsurf.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/brushbatchrender.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_shader.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_drawlights.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_lightmap.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_matsysiface.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_rlight.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_rmain.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_rmisc.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_screen.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gl_warp.cpp")
endif()

target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/l_studio.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/matsys_interface.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/modelloader.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/Overlay.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/r_areaportal.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/r_decal.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/r_linefile.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/shadowmgr.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_ipratelimit.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_rcon.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_steamauth.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_uploaddata.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_uploadgamestats.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/baseclient.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_main.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_client.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_ents_write.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_filter.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_framesnapshot.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_log.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_master.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_packedentities.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_plugin.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_precache.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_redirect.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sv_remoteaccess.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vengineserver_impl.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/baseautocompletefilelist.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/baseserver.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/bitbuf_errorhandler.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/blackbox.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/blockingudpsocket.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/bsptreedata.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/builddisp.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/buildnum.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/changeframelist.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/checksum_engine.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/clockdriftmgr.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cl_bounded_cvars.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cmd.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cmodel.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cmodel_bsp.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cmodel_disp.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/collisionutils.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/common.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/crtmemdebug.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cvar.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/disp_common.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/disp_defs.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/disp_helpers.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/disp_powerinfo.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/dispcoll_common.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/DownloadListGenerator.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/downloadthread.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_common_eng.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_encode.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_instrumentation.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_instrumentation_server.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_localtransfer.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/dt_recv.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_recv_decoder.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_recv_eng.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/dt_send.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_send_eng.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_stack.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/dt_test.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/dt_utlvector_common.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/dt_utlvector_recv.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/dt_utlvector_send.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/enginesingleuserfilter.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/enginestats.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/enginethreads.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/enginetrace.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/filesystem_engine.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/filesystem_helpers.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/filesystem_init.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/filetransfermgr.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/GameEventManager.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/GameEventManagerOld.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gameeventtransmitter.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/gametrace_engine.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/hltvclient.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/hltvclientstate.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/hltvdemo.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/hltvbroadcast.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/hltvserver.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/hltvtest.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/host.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/host_cmd.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/host_listmaps.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/host_phonehome.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/host_state.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/imagepacker.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/initmathlib.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/language.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/LocalNetworkBackdoor.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/LoadScreenUpdate.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/lumpfiles.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/MapReslistGenerator.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/materialproxyfactory.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/mem_fgets.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/mod_vis.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/ModelInfo.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/netconsole.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/net_chan.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/net_support.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/net_synctags.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/net_ws.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/net_ws_queued_packet_sender.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/net_steamsocketmgr.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/netmessages.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/steamid.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/networkstringtable.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/NetworkStringTableItem.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/networkstringtableserver.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/networkvar.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/packed_entity.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/pure_server.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/pr_edict.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/precache.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/quakedef.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/randomstream.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/randoverride.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/registry.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/replay.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/replayclient.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/replayhistorymanager.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/replaydemo.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/replayserver.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/sentence.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/singleplayersharedmemory.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sound_shared.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/spatialpartition.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/staticpropmgr.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/status.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/studio.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sys_dll.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sys_dll2.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sys_engine.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sys_mainwind.cpp")
endif()
if( LINUXALL )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sys_linuxwind.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/testscriptmgr.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/traceinit.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/vallocator.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/voiceserver_impl.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vprof_engine.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vprof_record.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/world.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/XZip.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/XUnzip.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/zone.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/bugreporter.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/cheatcodes.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/download.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/editor_sendcommand.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/host_saverestore.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/keys.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/lightcache.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/networkstringtableclient.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/saverestore_filesystem_passthrough.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/saverestore_filesystem.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/scratchpad3d.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/servermsghandler.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/sys_getmodes.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_askconnectpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_watermark.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/xboxsystem.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/SourceAppInfo.cpp")
if( WINDOWS )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/ipc_console.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/engine/paint.cpp")
target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/phonemeconverter.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/snd_io.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/EngineSoundServer.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/EngineSoundClient.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/engsoundservice.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_wavefile.cpp")
if( NOT DEDICATED AND NOT X360 )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/MPAFile.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/MPAHeader.cpp")
endif()
if( POSIX )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_posix.cpp")
endif()
if( WINDOWS )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/windows_audio.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/vox.cpp")
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_dev_common.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_dma.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_mixgroups.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_dsp.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_mix.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_system.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_entry_match_system.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_block_entry.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_convar.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_dashboard.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_delta.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_distant_dsp.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_entry_time.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_entity_info.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_falloff.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_filters.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_iterate_merge_speakers.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_map_name.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_math.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_mixer.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_mixlayer.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_occlusion.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_opvar.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_output.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_platform.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_player_info.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_pos_vec8.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_source_info.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_spatialize.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_start_entry.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_stop_entry.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_sys_time.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_tracks.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_op_sys/sos_op_util.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_sentence_mixer.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_wave_data.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_wave_mixer.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_wave_mixer_adpcm.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_wave_source.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_wave_temp.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_win.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_gain.cpp")
endif()
if( WINDOWS )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_dev_direct.cpp")
endif()
if( WINDOWS OR OSXALL OR (LINUXALL AND NOT DEDICATED) )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_mp3_source.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_wave_mixer_mp3.cpp")
endif()
if( NOT DEDICATED AND NOT X360 )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/VBRHeader.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice.cpp")
endif()
if( WINDOWS )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_mixer_controls.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_record_dsound.cpp")
endif()
if( NOT DEDICATED AND NOT X360 )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_sound_engine_interface.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/snd_stubs.cpp")
if( OSXALL OR (LINUXALL AND NOT DEDICATED) )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_mixer_controls_openal.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_record_openal.cpp")
endif()
if( OSXALL )
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/audio/private/voice_record_mac_audioqueue.cpp")
endif()
if( NOT DEDICATED )
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/public/vgui_controls/vgui_controls.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/vgui/vgui_basebudgetpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/vgui/vgui_budgetbargraphpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/vgui/vgui_budgethistorypanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${SRCDIR}/common/vgui/vgui_budgetpanelshared.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/perfuipanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_basepanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_baseui_interface.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_budgetpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_DebugSystemPanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_drawtreepanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_helpers.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_texturebudgetpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_vprofgraphpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/vgui_vprofpanel.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/enginetool.cpp")
    target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/toolframework.cpp")
endif()
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/bsplog.cpp")
target_sources(${OUTBINNAME} PRIVATE "${ESRCDIR}/serializedentity.cpp") #valve had this in the header section >:(

if( (NOT DEFINED NO_STEAM) )
    #grug
    #Looks like we have to include libsteam_api
    message("building with steam_api")
    target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/libsteam_api.so)
else()
    #message(FATAL_ERROR "CMake steam_api integration is disabled.")
    message(FATAL_ERROR "We have to build with steam currently =(")
endif()

#Link order actually does matter, so be careful if you cleanup these nasty if's
target_link_libraries(${OUTBINNAME} appframework_client bitmap_client dmxloader_client mathlib_client)
if( NOT DEDICATED )
    target_link_libraries(${OUTBINNAME} matsys_controls_client soundsystem_lowlevel)
endif()
target_link_libraries(${OUTBINNAME} libtier0_client tier2_client tier3_client libvstdlib_client)
if( WINDOWS OR OSXALL OR (LINUXALL AND NOT DEDICATED) )
    target_link_libraries(${OUTBINNAME} videocfg_client)
endif()
target_link_libraries(${OUTBINNAME} vtf_client)
if( NOT DEDICATED )
    target_link_libraries(${OUTBINNAME} vgui_controls_client)
endif()
if( NOT VS2015 )
    if( KISAK_USE_SDR )
        add_definitions(-DKISAK_USE_SDR)
        target_link_libraries(${OUTBINNAME} ${LIBPUBLIC}/steamdatagramlib_client.a) #Link with Evil Proprietary steamdatagram lib
    endif()
else()
    message(FATAL_ERROR "Visual Studio 2015 detected... Weird.")
endif()
target_link_libraries(${OUTBINNAME} bzip2_client)
if( WINDOWS OR OSXALL OR (LINUXALL AND NOT DEDICATED) )
    target_link_libraries(${OUTBINNAME} jpeglib_client)
endif()
target_link_libraries(${OUTBINNAME} libprotobuf) #from /thirdparty
if( LINUXALL AND NOT DEDICATED )
    #Link to System-wide curl, openssl, zlib, and crypto
    target_link_libraries(${OUTBINNAME} curl ssl z crypto)
endif()
target_link_libraries(${OUTBINNAME} quickhull_client)
if( SDL AND NOT LINUXALL )
    #$ImpLib	"SDL2" [$SDL && !$LINUXALL]
endif()

if( LINUX64 AND NOT DEDICATED )
    if( USE_VALVE_HRTF )
        target_link_libraries(${OUTBINNAME} ${LIBCOMMON}/libphonon3d.so) #link to Blob for proprietary 3d audio.
        add_definitions(-DUSE_VALVE_HRTF)
        message("Using SteamAudio HRTF blob.\n")
    else()
        message("Using Standard CS:GO Audio.\n")
    endif()
endif()

if( (LINUXALL AND DEDICATED) OR OSXALL )
    #target_link_libraries(${OUTBINNAME} ${SRCDIR}/lib${PLATSUBDIR}/release/libcryptopp.a)
    target_link_libraries(${OUTBINNAME} cryptopp-object) #target from /external/cryptopp cmake
elseif( LINUXALL AND NOT DEDICATED )
    #target_link_libraries(${OUTBINNAME} ${SRCDIR}/lib${PLATSUBDIR}/release/libcryptopp_client.a) #built by us in the setup phase
    target_link_libraries(${OUTBINNAME} cryptopp-object) #target from /external/cryptopp cmake
endif()