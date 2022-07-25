$(document).on('click', '.test-label', function() {
  dymo.label.framework.init();

  let xmlLabel = `<?xml version="1.0" encoding="utf-8"?>
        <DieCutLabel Version="8.0" Units="twips">
            <PaperOrientation>Landscape</PaperOrientation>
            <Id>Address</Id>
            <PaperName>30252 Address</PaperName>
            <DrawCommands>
                <RoundRectangle X="0" Y="0" Width="1581" Height="5040" Rx="270" Ry="270" />
            </DrawCommands>
            <ObjectInfo>
                <BarcodeObject>
                    <Name>Barcode</Name>
                    <ForeColor Alpha="255" Red="0" Green="0" Blue="0" />
                    <BackColor Alpha="0" Red="255" Green="255" Blue="255" />
                    <LinkedObjectName></LinkedObjectName>
                    <Rotation>Rotation0</Rotation>
                    <IsMirrored>False</IsMirrored>
                    <IsVariable>False</IsVariable>
                    <Text></Text>
                    <Type>QRCode</Type>
                    <Size>Large</Size>
                    <TextPosition>None</TextPosition>
                    <TextFont Family="Arial" Size="8" Bold="False" Italic="False" Underline="False" Strikeout="False" />
                    <CheckSumFont Family="Arial" Size="8" Bold="False" Italic="False" Underline="False" Strikeout="False" />
                    <TextEmbedding>None</TextEmbedding>
                    <ECLevel>0</ECLevel>
                    <HorizontalAlignment>Left</HorizontalAlignment>
                    <QuietZonesPadding Left="0" Top="0" Right="0" Bottom="0" />
                </BarcodeObject>
                <Bounds X="331" Y="57.9999999999999" Width="2880" Height="1435" />
            </ObjectInfo>
        </DieCutLabel>`;
  let barcodeLabel = dymo.label.framework.openLabelXml(xmlLabel);
  var pngData = barcodeLabel.render();
  var labelImage = document.getElementById('labelImage');
  labelImage.src = "data:image/png;base64," + pngData;
  console.log('here');
});
