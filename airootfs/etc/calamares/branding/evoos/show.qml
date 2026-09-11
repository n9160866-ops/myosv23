import QtQuick 2.0;

Rectangle {
    color: "#1a1f2b"
    Text {
        anchors.centerIn: parent
        color: "#ffffff"
        font.pixelSize: 28
        text: "Installation d'EvoOS en cours...\nMerci de patienter."
        horizontalAlignment: Text.AlignHCenter
    }

    function nextSlide() {}
}
