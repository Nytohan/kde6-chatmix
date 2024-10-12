import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    Layout.minimumHeight: 100
    Layout.minimumWidth: 100
    Layout.preferredWidth: Layout.minimumWidth
    Layout.preferredHeight: Layout.minimumHeight

    signal battPercentUpdated(percentage: int)
    preferredRepresentation: fullRepresentation

    function getBattPercent(){
        battexec.exec(plasmoid.configuration.BatteryCommand);
    }

    function getChatMixVal(){
        mixexec.exec(plasmoid.configuration.ChatmixCommand);
    }

    function logprops(){
        console.log(root.props.state)
    }

	
    Plasma5Support.DataSource {
		id: battexec
		engine: "executable"
		connectedSources: []
		onNewData: (source, data) => {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
            exited(source, exitCode, exitStatus, stdout, stderr)
			disconnectSource(source) // cmd finished
		}

		function exec(cmd) {
			if (cmd) {
				connectSource(cmd)
			}
		}
		signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
	}

    Plasma5Support.DataSource {
		id: mixexec
		engine: "executable"
		connectedSources: []
		onNewData: (source, data) => {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
            exited(source, exitCode, exitStatus, stdout, stderr)
			disconnectSource(source) // cmd finished
		}

		function exec(cmd) {
			if (cmd) {
				connectSource(cmd)
			}
		}
		signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
	}

    Plasma5Support.DataSource {
        id: setvol
        engine: "executable"
        connectedSources: []
        onNewData: (source, data) => {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
            exited(source, exitCode, exitStatus, stdout, stderr)
			disconnectSource(source) // cmd finished
		}

		function exec(cmd) {
			if (cmd) {
				connectSource(cmd)
			}
		}
		signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)
    }



    property var props:({
        chat: 100,
        media: 100,
        batt: 0,
        state:false
    })

    fullRepresentation: Item {

            Canvas {

                id: volCanvas
                width: parent.height
                height: width

                onPaint: {
                    //console.log("Painting")
                    var colors = {}
                    colors.chat     = plasmoid.configuration.ColorChat
                    colors.media    = plasmoid.configuration.ColorMedia
                    colors.unfilled = plasmoid.configuration.ColorUnfilled
                    var values = {}
                    values.state    = root.props.state
                    values.media    = root.props.media
                    values.chat     = root.props.chat

                    //console.log("Chat: "+root.props.chat)
                    //console.log("Media: "+root.props.media)

                    var ctx = getContext("2d");

                    ctx.clearRect(0,0, volCanvas.width, volCanvas.height)

                    ctx.reset();
                    //ctx.scale(.5,.5)
                    ctx.lineWidth = 16;

                    // Draw Audio Arcs
                    if(root.props.state){
                        // Blank Arc
                        //ctx.arc(x, y, r, startAngle, endAngle, <bool> clockwise); Angles are in PI Radians, Right = 0, 2, 4... Left = 1, 3... Clockwise by default.

                        ctx.strokeStyle = colors.unfilled;
                        ctx.beginPath();
                        context.translate(0.5,0.5);

                        // Paint full unfilled arc
                        ctx.arc(volCanvas.width / 2, volCanvas.height / 2, (volCanvas.width / 2)-ctx.lineWidth, 1.5 * Math.PI, 2.5 * Math.PI);
                        ctx.stroke();
                        ctx.closePath();

                        // Chat Arc (Top)
                        // Paint segment of the arc corresponding to Vol% of chat channel.

                        ctx.strokeStyle = colors.chat;
                        ctx.beginPath();
                        //scontext.translate(0.5,0.5);
                        ctx.arc(volCanvas.width / 2, volCanvas.height / 2, (volCanvas.width / 2)-ctx.lineWidth, 1.5 * Math.PI, 1.5 * Math.PI + (0.5*Math.PI)*values.chat/100);
                        ctx.stroke();
                        ctx.closePath();

                        // Media Arc (Bottom)
                        // Paint segment of the arc corresponding to Vol% of media channel.
                        ctx.strokeStyle = colors.media;
                        ctx.beginPath();
                        //context.translate(0.5,0.5);
                        ctx.arc(volCanvas.width / 2, volCanvas.height / 2, (volCanvas.width / 2)-ctx.lineWidth, (0.5*Math.PI)*(100 - values.media)/100, 0.5 * Math.PI);
                        ctx.stroke();
                        ctx.closePath();


                        ctx.textAlign = "right";
                        ctx.textBaseline = "top";
                        ctx.fillStyle = colors.chat
                        ctx.font = "bold "+ctx.lineWidth+"px sans-serif";
                        ctx.fillText("CHAT", volCanvas.width/2-ctx.lineWidth/2, ctx.lineWidth/4);

                        ctx.textBaseline = "bottom";
                        ctx.fillStyle = colors.media
                        ctx.font = "bold "+ctx.lineWidth+"px sans-serif";
                        ctx.fillText("MEDIA", volCanvas.width/2-ctx.lineWidth/2, volCanvas.height-ctx.lineWidth/4);
                    } else {
                        // Draw power symbol
                        ctx.strokeStyle = colors.media;
                        ctx.beginPath();
                        context.translate(0.5,0.5);

                        // Paint full unfilled arc
                        ctx.arc(volCanvas.width / 2, volCanvas.height / 2, (volCanvas.width / 2)-ctx.lineWidth, 1.75 * Math.PI, 3.25 * Math.PI);
                        ctx.stroke();
                        ctx.closePath();

                        ctx.strokeStyle = colors.chat;
                        ctx.beginPath();
                        ctx.moveTo(volCanvas.width / 2, volCanvas.height / 2)
                        
                        ctx.lineTo(volCanvas.width / 2, 0)
                        ctx.stroke()
                        ctx.closePath();

                    }


                }
                layer.enabled: true

            }
        //}

        Connections {
            target: mixexec
            function onExited (cmd, exitCode, exitStatus, stdout, stderr){
                //console.log("STDOUT: "+stdout)
                if(root.props.state){
                    var midpoint = 64;
                    var value = stdout - midpoint;
                    var chat = 100;
                    var media = 100;
                    if(value < 0){
                        media = 100;
                        chat = Math.round(100 - (((value * -1)/64)*100));
                    } else {
                        media = Math.round(100 - (((value)/64)*100));
                        chat = 100;
                    }
                    
                    //mixLabel.text = "Chat: "+chat+"\nMedia: "+media;

                    if(root.props.media != media){
                        console.log("Media changed: "+ root.props.media + " => " + media)
                        setvol.exec("pactl set-sink-volume \"Arctis Media\" "+media+"%")
                        root.props.media = media;
                    }

                    if(root.props.chat != chat){
                        console.log("Chat changed: " + root.props.chat + " => " + chat)
                        setvol.exec("pactl set-sink-volume \"Arctis Chat\" "+chat+"%")
                        root.props.chat = chat;
                    }
                }
            }
        }

        Connections {
            target: battexec
            function onExited (cmd, exitCode, exitStatus, stdout, stderr){
                root.props.batt = stdout;
                root.props.state = !!stdout;
                if(root.props.state){
                    //battLabel.text = "Battery: " + stdout.trim();
                } else{
                    //battLabel.text = "Headset powered off";
                }
            }
        }

        Timer {
            id: timer
            interval: 10
            repeat: true
            running: true
            triggeredOnStart: true
            onTriggered: function(){
                getChatMixVal()
                getBattPercent()
                volCanvas.requestPaint()
            }
            Component.onCompleted: {
			    // Run right away in case the interval is very long.
			    triggered()
		    }
        }
    }
}