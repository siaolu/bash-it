# Function to check if a command exists
function command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to display messages
function dispmsg() {
  local message="$1"
  echo "$message"
}

# Function to display command not found message
function cmdnf() {
  local command="$1"
  dispmsg "$command command not found. Please install $command or use an alternate method."
}

# Logging functions
function log_operation() {
  local operation=$1
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Operation: $operation" >> $LOG_FILE
}

function log_execution_time() {
  local function_name=$1
  local start_time=$2
  local end_time=$(date +%s)
  local execution_time=$((end_time - start_time))
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Function: $function_name, Execution Time: $execution_time seconds" >> $LOG_FILE
}

function extract() {
  local start_time=$(date +%s)
  log_operation "extract"

  if [ -z "$1" ]; then
    # display usage if no parameters given
    dispmsg "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    dispmsg "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    log_execution_time "${FUNCNAME[0]}" $start_time
    return 1
  else
    for n in "$@"; do
      if [ -f "$n" ]; then
        case "${n%,}" in
          *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
            if command_exists tar; then
              tar xvf "$n"
            else
              cmdnf "tar"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.lzma)
            if command_exists unlzma; then
              unlzma "./$n"
            else
              cmdnf "unlzma"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.bz2)
            if command_exists bunzip2; then
              bunzip2 "./$n"
            else
              cmdnf "bunzip2"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.rar)
            if command_exists unrar; then
              unrar x -ad "./$n"
            else
              cmdnf "unrar"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.gz)
            if command_exists gunzip; then
              gunzip "./$n"
            else
              cmdnf "gunzip"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.zip)
            if command_exists unzip; then
              unzip "./$n"
            else
              cmdnf "unzip"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.z)
            if command_exists uncompress; then
              uncompress "./$n"
            else
              cmdnf "uncompress"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
            if command_exists 7z; then
              7z x "./$n"
            else
              cmdnf "7z"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.xz)
            if command_exists unxz; then
              unxz "./$n"
            else
              cmdnf "unxz"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.exe)
            if command_exists cabextract; then
              cabextract "./$n"
            else
              cmdnf "cabextract"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *)
            dispmsg "extract: '$n' - unknown archive method"
            log_execution_time "${FUNCNAME[0]}" $start_time
            return 1
            ;;
        esac
      else
        dispmsg "extract: '$n' - file does not exist"
        log_execution_time "${FUNCNAME[0]}" $start_time
        return 1
      fi
    done
  fi

  log_execution_time "${FUNCNAME[0]}" $start_time
}

function xcompress() {
  local start_time=$(date +%s)
  log_operation "xcompress"

  if [ -z "$1" ]; then
    # display usage if no parameters given
    dispmsg "Usage: xcompress <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    dispmsg "       xcompress <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    log_execution_time "${FUNCNAME[0]}" $start_time
    return 1
  else
    for n in "$@"; do
      if [ -f "$n" ]; then
        case "${n%,}" in
          *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
            if command_exists tar; then
              tar cvf "${n%.*}.tar" "${n%.*}/"
            else
              cmdnf "tar"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.lzma)
            if command_exists lzma; then
              lzma "./${n%.*}"
            else
              cmdnf "lzma"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.bz2)
            if command_exists bzip2; then
              bzip2 "./${n%.*}"
            else
              cmdnf "bzip2"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.rar)
            if command_exists rar; then
              rar a "./${n%.*}.rar" "./${n%.*}/"
            else
              cmdnf "rar"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.gz)
            if command_exists gzip; then
              gzip "./${n%.*}"
            else
              cmdnf "gzip"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.zip)
            if command_exists zip; then
              zip "./${n%.*}.zip" "./${n%.*}/"
            else
              cmdnf "zip"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.z)
            if command_exists compress; then
              compress "./${n%.*}"
            else
              cmdnf "compress"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.7z)
            if command_exists 7z; then
              7z a "./${n%.*}.7z" "./${n%.*}/"
            else
              cmdnf "7z"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.arj)
            if command_exists arj; then
              arj a "./${n%.*}.arj" "./${n%.*}/"
            else
              cmdnf "arj"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.cab)
            if command_exists lcab; then
              lcab "./${n%.*}" "./${n%.*}.cab"
            else
              cmdnf "lcab"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.chm)
            if command_exists hha; then
              hha "./${n%.*}" "./${n%.*}.chm"
            else
              cmdnf "hha"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.deb)
            if command_exists dpkg-deb; then
              dpkg-deb -b "./${n%.*}" "./${n%.*}.deb"
            else
              cmdnf "dpkg-deb"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.dmg)
            if command_exists hdiutil; then
              hdiutil create -srcfolder "./${n%.*}" -format UDZO "./${n%.*}.dmg"
            else
              dispmsg "xcompress: 'hdiutil' command not found. DMG compression is only supported on macOS."
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.iso)
            if command_exists mkisofs; then
              mkisofs -o "./${n%.*}.iso" "./${n%.*}/"
            else
              cmdnf "mkisofs"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.lzh)
            if command_exists lha; then
              lha a "./${n%.*}.lzh" "./${n%.*}/"
            else
              cmdnf "lha"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.msi|*.rpm)
            dispmsg "xcompress: '${n}' - not supported for compression"
            log_execution_time "${FUNCNAME[0]}" $start_time
            return 1
            ;;
          *.udf)
            if command_exists mkudffs; then
              mkudffs --media-type=hd --udfrev=2.01 --blocksize=512 --vid="${n%.*}" --label="${n%.*}" "./${n%.*}.udf" "./${n%.*}/"
            else
              cmdnf "mkudffs"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.wim)
            if command_exists mkwinpeimg; then
              mkwinpeimg --windows-dir="./${n%.*}" --output-file="./${n%.*}.wim"
            else
              cmdnf "mkwinpeimg"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.xar)
            if command_exists xar; then
              xar -cf "./${n%.*}.xar" "./${n%.*}/"
            else
              cmdnf "xar"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.xz)
            if command_exists xz; then
              xz "./${n%.*}"
            else
              cmdnf "xz"
              log_execution_time "${FUNCNAME[0]}" $start_time
              return 1
            fi
            ;;
          *.exe)
            dispmsg "xcompress: '${n}' - not supported for compression"
            log_execution_time "${FUNCNAME[0]}" $start_time
            return 1
            ;;
          *)
            dispmsg "xcompress: '${n}' - unknown archive method"
            log_execution_time "${FUNCNAME[0]}" $start_time
            return 1
            ;;
        esac
      else
        dispmsg "xcompress: '${n}' - file does not exist"
        log_execution_time "${FUNCNAME[0]}" $start_time
        return 1
      fi
    done
  fi

  log_execution_time "${FUNCNAME[0]}" $start_time
}
