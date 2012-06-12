/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import "tweetsearch.js" as Helper

Item {
    id: container
    property real hm: 1.0
    property int appear: -1
    property real startRotation: 1

    onAppearChanged: {
        container.startRotation = 0.5
        flipBar.animDuration = appear;
        delayedAnim.start();
    }

    SequentialAnimation {
        id: delayedAnim
        PauseAnimation { duration: 50 }
        ScriptAction { script: flipBar.flipDown(startRotation); }
    }

    width: 320
    height: flipBar.height * hm

    FlipBar {
        id: flipBar

        property bool flipped: false
        delta: startRotation
//        wiggleDuration: 120
//        wiggleRoom: 2

        anchors.bottom: parent.bottom
        width: container.ListView.view ? container.ListView.view.width : 0
        height: Math.max(72, tweet.y + tweet.height + 10)

        front: Rectangle {
            width: container.ListView.view ? container.ListView.view.width : 0
            height: Math.max(72, tweet.y + tweet.height + 10)
            color: "#2699bf"

            Rectangle { color: "#33ccff"; width: parent.width; height: 1 }
            Rectangle { color: "#1a6680"; width: parent.width; height: 1; anchors.bottom: parent.bottom }

            Image {
                id: placeHolder
                source: "resources/anonymous.png"
                x: 10; y: 9
                visible: avatar.status != Image.Ready
            }
            Image {
                id: avatar
                source: model.userImage
                anchors.fill: placeHolder
            }

            Text {
                id: name
                text: Helper.realName(model.name)
                anchors { left: avatar.right; leftMargin: 10; top: avatar.top; topMargin: -3 }
                font.pixelSize: 12
                font.bold: true
                color: "white"
                linkColor: "white"
            }

            Text {
                id: tweet
                text: model.statusText
                anchors { left: avatar.right; leftMargin: 10; top: name.bottom; topMargin: 0; right: parent.right; rightMargin: 10 }
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                font.bold: false
                color: "#adebff"
                linkColor: "white"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    if (!flipBar.flipped) {
                        flipBar.flipUp()
                        flipBar.flipped = true
                    } else {
                        flipBar.flipDown()
                        flipBar.flipped = false
                    }
                }
            }
        }

        back: Rectangle {
            width: container.ListView.view ? container.ListView.view.width : 0
            height: Math.max(72, tweet.y + tweet.height + 10)
            color: "#be4a25"

            Rectangle { color: "#ff6633"; width: parent.width; height: 1 }
            Rectangle { color: "#80341a"; width: parent.width; height: 1; anchors.bottom: parent.bottom }

            Image {
                id: avatar2
                source: model.userImage
                anchors.right: parent.right
                anchors.rightMargin: 10
                y: 9
            }

            Text {
                id: username
                text: Helper.twitterName(model.name)
                x: 10; anchors { top: avatar2.top; topMargin: -3 }
                font.pixelSize: 12
                font.bold: true
                color: "white"
                linkColor: "white"
            }

            Text {
                text: model.source + "<br>" + Helper.formatDate(model.published) + "<br>" + model.uri
                x: 10; anchors { top: username.bottom; topMargin: 0 }
                wrapMode: Text.WordWrap
                font.pixelSize: 12
                font.bold: false
                color: "#ffc2ad"
                linkColor: "white"
                onLinkActivated: Qt.openUrlExternally(link);

            }
        }
    }
}