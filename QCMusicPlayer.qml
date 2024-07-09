import QtQuick
import QtMultimedia

MediaPlayer {
    id: p_musicPlayer
    enum PlayerMode {  //枚举循环类型
        ONELOOPPLAY = 0, // 单曲循环
        LOOPPLAY, // 列表循环
        RANDOMPLAY, // 随机播放
        PLAYLISTPLAY // 列表播放
    }
    property int playerModeCount: 4        //播放模式的总数
    property int playerModeStatus: QCMusicPlayer.PlayerMode.LOOPPLAY  //设置当前播放模式，默认为LOOPPLAY
    property double volume: 1.
    property double lastVolume: 1.
    audioOutput: AudioOutput {
        volume: p_musicPlayer.volume
    }

    onPlaybackStateChanged: {//当 MediaPlayer 的播放状态发生改变时触发，如果播放结束 (StoppedState) 且播放位置等于总时长，则调用 autoNextMusicPlay 函数自动播放下一首
        if(playbackState === MediaPlayer.StoppedState && duration === position) {
            autoNextMusicPLay()
        }
    }

    //切换播放模式
    function setPlayMode() {
        playerModeStatus = (playerModeStatus+1) % playerModeCount
    }

    /*
       播放音乐
    */
    function playMusic(id,musicInfo) {
        var musicUrlCallBack = res => {
            musicInfo.url = res.url
            p_musicRes.thisPlayMusicInfo = musicInfo
            play()
        }
        if(musicInfo.url !== "") {
            p_musicRes.thisPlayMusicInfo = musicInfo
            play()
        } else {
            p_musicRes.getMusicUrl({id,callBack:musicUrlCallBack})
        }
    }
    /*
        暂停或播放音乐
    */
    function playPauseMusic() {
        // 没有播放源就不操作
        if(playing) {
            pause()
        } else {
            play()
        }
    }
    /*
        上一首音乐
    */
    function preMusicPlay() {
        var index = p_musicRes.thisPlayCurrent
        if(index <= 0) {
            return
        }
        if(playerModeStatus === QCMusicPlayer.PlayerMode.RANDOMPLAY) {
            if(index !== p_musicRes.randomPlayCurrent) {
                for(let i = 0 ; i < p_musicRes.randomPlayListIndex.length;i++) {
                    if(index === p_musicRes.randomPlayListIndex[i]) { // 记录出现的位置
                        index = i
                        break
                    }
                }
            }
            p_musicRes.randomPlayCurrent = (index - 1) % p_musicRes.randomPlayListIndex.length
            index = p_musicRes.randomPlayListIndex[p_musicRes.randomPlayCurrent]
        } else {
            index = (index + 1) % p_musicRes.thisPlayListInfo.count
        }
        p_musicRes.thisPlayCurrent = index
        playMusic(p_musicRes.thisPlayListInfo.get(index).id,p_musicRes.thisPlayListInfo.get(index))
    }
    /*
        下一首音乐
    */
    function nextMusicPlay() {
        var index = p_musicRes.thisPlayCurrent
        if(p_musicRes.thisPlayListInfo.count <=0) {
            return
        }
        if(playerModeStatus === QCMusicPlayer.PlayerMode.RANDOMPLAY) {
            if(index !== p_musicRes.randomPlayCurrent) {
                for(let i = 0 ; i < p_musicRes.randomPlayListIndex.length;i++) {
                    if(index === p_musicRes.randomPlayListIndex[i]) { // 记录出现的位置
                        index = i
                        break
                    }
                }
            }
            p_musicRes.randomPlayCurrent = (index+1) % p_musicRes.randomPlayListIndex.length
            index = p_musicRes.randomPlayListIndex[p_musicRes.randomPlayCurrent]
        } else {
            index = (index + 1) % p_musicRes.thisPlayListInfo.count
        }

        p_musicRes.thisPlayCurrent = index
        playMusic(p_musicRes.thisPlayListInfo.get(index).id,p_musicRes.thisPlayListInfo.get(index))
    }
    /*
        自动播放下一首音乐
    */
    function autoNextMusicPLay() {
        switch(p_musicPlayer.playerModeStatus) {
        case QCMusicPlayer.PlayerMode.ONELOOPPLAY:
            play()
            break
        case QCMusicPlayer.PlayerMode.LOOPPLAY:
            nextMusicPlay()
            break
        case QCMusicPlayer.PlayerMode.RANDOMPLAY:
            nextMusicPlay()
            break
        case QCMusicPlayer.PlayerMode.PLAYLISTPLAY:
            if(p_musicRes.thisPlayListInfo.count-1 === p_musicRes.thisPlayCurrent) {
                // 当前是最后一首什么都不做
            } else {
                nextMusicPlay()
            }
            break
        }
    }
}
