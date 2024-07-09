import QtQuick

Item {

    property int thisPlayCurrent: -1                 //当前播放音乐的索引
    property int randomPlayCurrent: -1               //当前播放音乐的索引
    property var thisPlayMusicInfo: {                //定义前播放音乐的信息，包含音乐 ID、名称、艺术家、专辑、封面图片、URL 和总时长
        "id": "",
        "name": "",
        "artists": "",
        "album": "",
        "coverImg": "",
        "url": "",
        "allTime": "00:00",
    }
    property ListModel thisPlayListInfo: ListModel { //当前播放列表的信息

    }
    property ListModel thisPlayMusicLyric: ListModel {//当前播放音乐的歌词

    }
    // 随机播放的下标
    property var randomPlayListIndex: []
    onThisPlayMusicInfoChanged: {//当 thisPlayMusicInfo 变化时，获取新的歌词并更新 thisPlayMusicLyric
        console.log("播放歌曲信息: " + JSON.stringify(thisPlayMusicInfo))

        var lyricCallBack = res => {
            console.log(JSON.stringify(res))
            thisPlayMusicLyric.clear()
            thisPlayMusicLyric.append(res)
        }
        if(thisPlayMusicInfo.id) {

            getMusicLyric({id: thisPlayMusicInfo.id,callBack: lyricCallBack})
        }

    }
    onThisPlayListInfoChanged: {//当 thisPlayListInfo 变化时，生成随机播放的下标列表并打乱顺序
        randomPlayListIndex = Array.from({length: thisPlayListInfo.count},(_,index) => index)

        for(let i = randomPlayListIndex.length-1;i > 0;i--) { // 打乱
            const index = Math.floor(Math.random() * (i+1));
            [randomPlayListIndex[i], randomPlayListIndex[index]] = [randomPlayListIndex[index], randomPlayListIndex[i]];
        }

        console.log(JSON.stringify(randomPlayListIndex))
    }

    //返回指定音乐 ID 在播放列表中的索引
    function indexOf(id) {
        if(thisPlayListInfo.count <= 0) return -1
        for(let i = 0 ;i < thisPlayListInfo.count;i++) {
            if(thisPlayListInfo.get(i).id === id) {
                return i
            }
        }
        return -1
    }
    /*
        获取歌词
    */
    //使用 XMLHttpRequest 获取指定音乐的歌词，并解析歌词
    function getMusicLyric(obj) {
        var id = obj.id || "0"
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText)
                    var lrc = res.lrc.lyric
                    var lyric = null
                    if(res.hasOwnProperty("pureMusic")) {
                        console.log("这是纯音乐")
                        lyric = parseLyric(lrc,"")
                    } else {
                        lyric = parseLyric(lrc,res.tlyric.lyric)
                    }

                    callBack(lyric)
                } else {
                    console.log("最新音乐获取失败： " + xhr.status)
                }
            }
        }

        xhr.open("GET","http://localhost:3000/lyric?id=" + id,true)
        xhr.send()
    }
    /*
        解析歌词
    */
    //解析获取到的歌词，并将翻译歌词合并到对应的时间戳中
    function parseLyric(lrc,tlrc) {

        var i = 0
        var lyric = {}

        lrc = lrc.split("\n")
        tlrc = tlrc.split("\n")

        for(i = 0; i < lrc.length;i++) { // 歌词
            if(!lrc[i]) continue
            let t = lrc[i].match(/\[(.*?)\]\s*(.*)/)
            let tim = t[1].split(":")
            tim = parseInt(tim[0]) * 60 * 1000 + parseInt(parseFloat(tim[1]) * 1000)
            lrc[i] = {tim: tim,lyric: t[2],tlrc: ""}
        }
        for(i = 0; i < tlrc.length;i++) { // 翻译歌词
            if(!tlrc[i]) continue
            let t = tlrc[i].match(/\[(.*?)\]\s*(.*)/)
            let tim = t[1].split(":")
            tim = parseInt(tim[0]) * 60 * 1000 + parseInt(parseFloat(tim[1]) * 1000)
            tlrc[i] = {tim: tim,tlrc: t[2]}
        }
        for(i = 0; i < lrc.length;i++) {
            let index = tlrc.findIndex(item => item.tim === lrc[i].tim )
            if(index !== -1) {
                lrc[i].tlrc = tlrc[index].tlrc
            }
        }
        // 去掉空的字段
        lrc = lrc.filter(item => item.lyric)
        return lrc
    }

    /*
        获取音乐URL
    */
    //使用 XMLHttpRequest 获取指定音乐的 URL
    function getMusicUrl(obj) {
        var id = obj.id || "0"
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).data[0]
                    callBack(res)
                } else {
                    console.log("最新音乐获取失败： " + xhr.status)
                }
            }
        }

        xhr.open("GET","http://localhost:3000/song/url?id=" + id,true)
        xhr.send()
    }
    /*
        获取最新音乐
    */
    //使用 XMLHttpRequest 获取最新音乐列表
    function getNewMusic(obj) {
        var type = obj.type || "0"
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).data
                    res = res.map(obj => {
                                    return {
                                          id: obj.id,
                                          name: obj.name,
                                          artists: obj.artists.map(ar => ar.name).join('/'),
                                          album: obj.album.name,
                                          coverImg: obj.album.picUrl,
                                          url: "",
                                          allTime: "00:00"
                                      }
                                  })
                    callBack(res)
                } else {
                    console.log("最新音乐获取失败： " + xhr.status)
                }
            }
        }

        xhr.open("GET","http://localhost:3000/top/song?type=" + type,true)
        xhr.send()
    }
    /*
        获取歌单
    */
    //使用 XMLHttpRequest 获取歌单列表
    function getMusicPlayList(obj) {
        var cat = obj.cat || "全部"
        var order = obj.order || "hot"
        var limit = obj.limit || "40"
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).playlists
                    res = res.map(obj => {
                                    return {
                                          id: obj.id,
                                          name: obj.name,
                                          description: obj.description,
                                          coverImg: obj.coverImgUrl.split('?')[0] ,
                                      }
                                  })
                    callBack(res)
                } else {
                    console.log("最新音乐获取失败： " + xhr.status)
                }
            }
        }

        xhr.open("GET","http://localhost:3000/top/playlist?cat=" +cat+ "&limit="+limit+"&order="+order,true)
        xhr.send()
    }
    /*
        获取精选歌单
    */
    //使用 XMLHttpRequest 获取精选歌单
    function getMusicBoutiquePlayList(obj) {
        var cat = obj.cat || "全部"
        var limit = obj.limit || "40"
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).playlists
                    res = res.map(obj => {
                                    return {
                                          id: obj.id,
                                          name: obj.name,
                                          description: obj.description,
                                          coverImg: obj.coverImgUrl.split('?')[0],
                                      }
                                  })
                    callBack(res)
                } else {
                    console.log("最新音乐获取失败： " + xhr.status)
                }
            }
        }
        xhr.open("GET","http://localhost:3000/top/playlist/highquality?cat=" +cat+ "&limit="+limit,true)
        xhr.send()
    }
    /*
        获取歌单详情
    */
    function getMusicPlayListDetail(obj) {
        var id = obj.id || ""
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).playlist
                    res = {
                        id: res.id,
                        name: res.name,
                        description: res.description,
                        coverImg: res.coverImgUrl.split('?')[0],
                        trackIds: res.trackIds.map(r => {return r.id })
                    }

                    callBack(res)
                } else {
                    console.log("最新音乐获取失败： " + xhr.status)
                }
            }
        }
        xhr.open("GET","http://localhost:3000/playlist/detail?id=" +id,true)
        xhr.send()
    }
    /*
        获取音乐详情
    */
    function getMusicDetail(obj) {
        var ids = obj.ids || ""
        var callBack = obj.callBack || (()=>{})
        var xhr = new XMLHttpRequest()
        xhr.onreadystatechange = function() {
            if(xhr.readyState === XMLHttpRequest.DONE) {
                if(xhr.status === 200) {
                    var res = JSON.parse(xhr.responseText).songs

                    res = res.map(obj => {
                                    return {
                                          id: obj.id,
                                          name: obj.name,
                                          artists: obj.ar.map(ar => ar.name).join('/'),
                                          album: obj.al.name,
                                          coverImg: obj.al.picUrl,
                                          url: "",
                                          allTime: setTime(obj.dt)
                                      }
                                  })
                    callBack(res)
                } else {
                    console.log("最新音乐获取失败： " + xhr.status)
                }
            }
        }
        xhr.open("GET","http://localhost:3000/song/detail?ids=" +ids,true)
        xhr.send()
    }

    //将毫秒时间转换为将毫秒时间转换为 "HH:MM" 格式的字符串
    function setTime(time) {
        var h = parseInt(time/1000 /3600)
        var m = parseInt(time/1000 /60)
        var s = parseInt(time/1000) %60

        h = h === 0 ? "" : h
        m = m < 10 ? "0"+ m : m
        s = s < 10 ? "0"+ s : s
        return h + (h === "" ? m : ":"+m) + ":" + s
    }
}
