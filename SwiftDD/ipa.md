#  打包脚本

    #第一个参数:打包环境(必传) 第二个参数:编译选项Debug/Release(必传) 第三个参数:版本号(可选) 第四个参数:描述
    #本地打包示例：sh ipa.sh -e 环境 -c 编译选项 -b 版本号 -d 描述
    compile="Release"
    while getopts ":e:c:b:d:" opt
    do
        case $opt in
            e)
            env=$OPTARG
            ;;
            c)
            compile=$OPTARG
            ;;
            b)
            bundleVersion=$OPTARG
            ;;
            d)
            desc=$OPTARG
            ;;
            ?)
            echo "未知参数"
            exit 1;;
        esac
    done

    #上传服务器配置
    appId="100"
    versionId="555"
    uploadUrl="http://255.255.255.255/ipa/upload.json"

    #打包环境检测
    if [ $env != "sit" -a $env != "pre" -a $env != "Pre" -a $env != "pre2" -a $env != "Pre2" -a $env != "pre3" -a $env != "Pre3" -a $env != "prd" ]; then
        echo "请输入正确的构建环境：[sit | pre | Pre | pre2 | Pre2 | pre3 | Pre3 | prd]"
        exit 1
    else
        build_env=$(echo $env | perl -pe 's/.*/\u$&/')
    fi
    
    #编译环境检测
    buildConfig=$compile
    if [ $compile != "Debug" -a $compile != "Release" ]; then
      echo "请输入正确的编译选项：[Debug | Release]"
      exit 1
    fi 
  
    #证书及描述文件
    if [ $buildConfig = "Release" ]; then
        CODE_SIGN_IDENTITY="iPhone Distribution: 签名 Appliance Co., Ltd."
        DEVELOPMENT_TEAM="5555555555"
        PROVISIONING_PROFILE_SPECIFIER="Profile_2018"
        EXPORT_OPTION_PLIST="ExportOptions.plist"     //工程目录下的文件
    else
        CODE_SIGN_IDENTITY="iPhone Developer: iisnhh"
        DEVELOPMENT_TEAM="其他"
        PROVISIONING_PROFILE_SPECIFIER="yysyy"
        EXPORT_OPTION_PLIST="ExportOptions-Debug.plist"
    fi
  
      #工程路径读取
      workspace_path="$(cd "$(dirname $0)" && pwd)"
      cd ${workspace_path}
      workspace_name=$(ls | grep xcworkspace)
      project_dir="工程所在的路径"
      project_path=${workspace_path}/${project_dir}
      project_name=$(ls ${project_dir} | grep xcodeproj | awk -F.xcodeproj '{print $1}')
      target_name=${project_name}
      info_plist=${project_path}/Project/${project_name}-Info.plist
      result_path=${workspace_path}/build/${build_env}_${buildConfig}_$(date +%Y-%m-%d_%H_%M)
  
      #工程代码更新
      echo "======开始更新代码======"
      cd ${project_path}
      git stash
      git pull --rebase
      cd ${workspace_path}
      pod update --no-repo-update --verbose
      if [ $? != 0 ]; then
          echo "======代码更新失败======"
          exit 1
      else
           echo "======完成代码更新======"
      fi
   
       #修改版本号
       if [ -n "$bundleVersion" ]; then
           bundleShortVersion=$(echo $bundleVersion | perl -pe 's/.*/\u$&/')
          /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${bundleShortVersion}" ${info_plist}
       else
          #主版本号读取
          bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${info_plist})
       fi

        #应用标识及名称修改
        case "$env" in
        sit|pre|pre2|pre3)
        bundle_identifier=com.gk.${build_env}
        bundle_name=${build_env}${bundleShortVersion}
        ;;
        Sit|Pre|Pre2|Pre3|Prd|prd)
        bundle_identifier=com.gk.Example
        bundle_name="app"
        ;;
        esac
     
     /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${bundle_identifier}" ${info_plist}
     /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName ${bundle_name}" ${info_plist}
   
   
       #Today Extension
       te_info_plist=${project_path}/NotificationBarForGK/Info.plist
       if [ -f ${nse_info_plist} ]; then
           te_bundle_identifier=${bundle_identifier}.NSExtension
           /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${te_bundle_identifier}" ${te_info_plist}
       fi

        #Notification Service Extension
        nse_info_plist=${project_path}/NotificationServiceExtension/Info.plist
        if [ -f ${nse_info_plist} ]; then
             nse_bundle_identifier=${bundle_identifier}.NotificationServiceExtension
             /usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${nse_bundle_identifier}" ${nse_info_plist}
        fi
        
        
        #打包环境修改
        config_file=${project_path}/Project/Src/Constants/BuildConfig.h  //工程目录下的环境
        
        if [ -f ${config_file} ]; then
        
        upper_env=$(echo ${build_env} | tr '[a-z]' '[A-Z]')
        
        echo "======修改环境配置======"
        sed -i '' "/TARGET_ENV_/ s/1/0/" ${config_file}
        sed -i '' "/TARGET_ENV_${upper_env}/ s/0/1/" ${config_file}
        
        sed -i '' "/DEBUG_ENABLE/ s/1/0/" ${config_file}
        
        fi

        ********************
        BuildConfig.h
        
        #define TARGET_ENV_PRE4     1    //测试环境1
        #define TARGET_ENV_PRE5     0    //测试环境2

        // 开发调试开关
        #define DEBUG_ENABLE    0
        

        ********************
        
        debug包删除推送功能
        if [ -f ${project_path}/工程.entitlements -a $buildConfig = "Debug" ]; then
        echo "======删除推送功能======"
        sed -i '' "/aps-environment/d" ${project_path}/工程.entitlements
        sed -i '' "/development/d" ${project_path}/工程.entitlements
        fi
        
        #构建路径设置
        mkdir -p "${result_path}"
        setting_out=${result_path}/build_setting.txt
        xcodebuild -showBuildSettings -workspace "${workspace_name}" -scheme "${target_name}" -configuration $buildConfig > ${setting_out}
        build_path=`echo $(grep -w  "CONFIGURATION_BUILD_DIR" ${setting_out} | awk -F= '{print $2}')`
        echo "======build_path: ${build_path}======"
        archive_path=${build_path}/${target_name}.xcarchive
        
        
        清除旧包
        rm -rf ${archive_path}
        #归档打包
        echo "======开始构建======"
        xcodebuild clean archive -workspace "${workspace_name}" \
        -scheme "${target_name}" \
        -archivePath ${archive_path} \
        -configuration $buildConfig \
        CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
        DEVELOPMENT_TEAM="${DEVELOPMENT_TEAM}" \
        PROVISIONING_PROFILE_SPECIFIER="${PROVISIONING_PROFILE_SPECIFIER}"
        
        echo "======检查是否构建成功======"
        if [ -d "${archive_path}" ]; then
        
        echo "构建成功......"
        
        else
        
        echo -e "\033[31m 构建失败，请修正后重新运行! \033[0m"
        rm -rf ${result_path}
        exit 1
        
        fi


        cd ${project_path}
        git checkout -- ${config_file}
        git checkout -- ${info_plist}
        git checkout -- 工程.xcodeproj/project.pbxproj
        git checkout -- ${project_path}/工程.entitlements

        ipa_name=${target_name}_${bundleShortVersion}.ipa
        ipa_path=${result_path}
        ExportOptionsPlist=${project_path}/$EXPORT_OPTION_PLIST
        
        #XCODE8 需要使用系统的ruby
        which rvm > /dev/null
        if [[ $? -eq 0 ]]; then
        echo "RVM detected, forcing to use system ruby"
        [ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"
        rvm use system
        fi
        
        #导出ipa
        xcodebuild -exportArchive \
        -archivePath ${archive_path} \
        -exportOptionsPlist ${ExportOptionsPlist} \
        -exportPath ${ipa_path}
        
        echo "======检查是否成功导出ipa======"
        ipa_temp_path=${ipa_path}/${target_name}.ipa
        if [ -f "${ipa_temp_path}" ]; then
        echo "导出ipa成功......"
        #ipa重命名
        mv "${ipa_temp_path}" "${ipa_path}/${ipa_name}"
        else
        echo -e "\033[31m 导出ipa失败...... \033[0m"
        exit 1
        fi
        
        #备份dSYM
        dsym_path=${archive_path}/dSYMs/${target_name}.app.dSYM/Contents/Resources/DWARF/${target_name}
        cp -R "${dsym_path}" "${result_path}/${target_name}.dSYM"
         
        
        #info名称
        ipa_info=${target_name}_${bundleShortVersion}.info
        echo ${target_name} ${bundleShortVersion} $env"($(date "+%Y-%m-%d %H:%M"))" > ${result_path}/${ipa_info}
        if [ -n "$desc" ]; then
           ipaDesc="我的app"$env$desc
        else
           ipaDesc="我的app"$env
        fi
       
       echo "======result_path: ${result_path}======"
       
       ###########################################文件上传###########################################
       if [ $buildConfig = "Release" ]; then
       echo "======开始上传测试包======"
       case "$build_env" in
       Pre|Pre2|Pre3)
       build_env="Pre";;
       esac
       cd ${result_path}
       #curl -T "{${ipa_name},${ipa_info}}" -u epp:ios ftp://上传路径/${build_env}/ipa/
       
       
       curl -F "appId=${appId}" -F "versionId=${versionId}" -F "bundleId=${bundle_identifier}" -F "ipaDesc=${ipaDesc}" -F "ipaFile=@${ipa_path}/${ipa_name}" ${uploadUrl}
       
       echo "======共耗时${SECONDS}秒======"
       fi

