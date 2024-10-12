import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.kirigami 2.5 as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_ColorChat: colorChat.text
    property alias cfg_ColorMedia: colorMedia.text
    property alias cfg_ColorUnfilled: colorUnfilled.text
    property alias cfg_ChatmixCommand: chatmixCommand.text
    property alias cfg_BatteryCommand: batteryCommand.text

    Kirigami.FormLayout {
        TextField {
            id: colorChat
            text: i18n("#D85D31")
            Kirigami.FormData.label: i18n("Chat dial:")
        }
        TextField {
            id: colorMedia
            text: i18n("#38A07E")
            Kirigami.FormData.label: i18n("Media dial:")
        }
        TextField {
            id: colorUnfilled
            text: i18n("#3c4146")
            Kirigami.FormData.label: i18n("Unfilled dial:")
        }
        TextField {
            id: chatmixCommand
            text: i18n("headsetcontrol -m | grep Chatmix | sed 's/Chatmix:\ //' | cut -f 2")
            Kirigami.FormData.label: i18n("Chatmix value command:")
        }

        TextField {
            id: batteryCommand
            text: i18n("headsetcontrol -b | grep % | sed 's/Level:\ //' | sed 's/%//' | cut -f 2")
            Kirigami.FormData.label: i18n("Battery value command:")
        }
    }
}
