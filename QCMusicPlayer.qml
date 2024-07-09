import QtQuick
import QtMultimedia

MediaPlayer {
    id: p_musicPlayer
    enum PlayerMode {
        ONELOOPPLAY = 0, // 单曲循环
        LOOPPLAY, // 列表循环
        RANDOMPLAY, // 随机播放
        PLAYLISTPLAY // 列表播放
    }
    property int playerModeCount: 4
    property int playerModeStatus: QCMusicPlayer.PlayerMode.LOOPPLAY
    property double volume: 1.
    property double lastVolume: 1.
    audioOutput: AudioOutput {
        volume: p_musicPlayer.volume
    }

    onPlaybackStateChanged: {
        if(playbackState === MediaPlayer.StoppedState && duration === position) {
            autoNextMusicPLay()
        }
    }

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
