<mxfile host="app.diagrams.net" modified="2020-07-17T17:46:39.921Z" agent="5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36" etag="i40D53PiBTw2pI4tGdh4" version="13.4.6" type="github">
  <diagram id="APbCHEt9h7LmyBrYfhhx" name="Page-1">
    <mxGraphModel dx="1422" dy="794" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="850" pageHeight="1100" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="TYA-corCzER_tpGZpnsk-2" value="Business Process" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="20" y="20" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-3" value="Technical Process" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" parent="1" vertex="1">
          <mxGeometry x="20" y="100" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-4" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" parent="1" vertex="1">
          <mxGeometry x="200" y="40" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-5" value="Trigger" style="text;html=1;strokeColor=#d79b00;fillColor=#ffe6cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="250" y="45" width="40" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-7" value="Borough User Submits SLA Change Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="80" y="270" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-8" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-7" target="TYA-corCzER_tpGZpnsk-9" edge="1">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="20" y="400" as="sourcePoint" />
            <mxPoint x="270" y="300" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-12" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-9" target="TYA-corCzER_tpGZpnsk-11" edge="1">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="430" y="300" />
              <mxPoint x="430" y="235" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-23" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-9" target="TYA-corCzER_tpGZpnsk-22" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-9" value="COO Focht Reviews Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="270" y="270" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-27" target="TYA-corCzER_tpGZpnsk-24" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-22" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;new record to tbl_change_request (which would include justification)&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="245" y="400" width="170" height="80" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-24" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;new record into tbl_change_request_status with &lt;br&gt;- sla_change_status = 1 for &quot;submitted&quot;&lt;br&gt;- status_date equal to the current date and time&lt;br&gt;- status_user to the user that submitted the request&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="177.5" y="600" width="305" height="100" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-15" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-9" target="TYA-corCzER_tpGZpnsk-14" edge="1">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="430" y="300" />
              <mxPoint x="430" y="350" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-18" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-11" target="TYA-corCzER_tpGZpnsk-17" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-11" value="Reject Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="600" y="205" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-17" value="&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;&lt;b&gt;Insert:&lt;/b&gt;&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;new record into tbl_change_request_status with sla_change_status = 2 for &quot;approved&quot; or sla_change_status = 3 for &quot;rejected&quot;&lt;/span&gt;&lt;/div&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" parent="1" vertex="1">
          <mxGeometry x="810" y="260" width="230" height="90" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-20" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-14" target="TYA-corCzER_tpGZpnsk-17" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="800" y="350" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-33" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-14" target="TYA-corCzER_tpGZpnsk-32" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-14" value="Approve Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="600" y="320" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-35" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-32" target="TYA-corCzER_tpGZpnsk-36" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="730" y="650" as="targetPoint" />
            <Array as="points">
              <mxPoint x="660" y="560" />
              <mxPoint x="720" y="560" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-40" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-32" target="TYA-corCzER_tpGZpnsk-39" edge="1">
          <mxGeometry relative="1" as="geometry">
            <Array as="points">
              <mxPoint x="660" y="560" />
              <mxPoint x="605" y="560" />
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-32" value="Is the effective_start date equal to today&#39;s date?" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="600" y="460" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-4" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-39" target="TYA-corCzER_tpGZpnsk-53">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-39" value="Yes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="580" y="610" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-21" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-17" target="TYA-corCzER_tpGZpnsk-17" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-28" value="&lt;b&gt;trg_i_tbl_change_request.sql&lt;/b&gt;" style="text;html=1;strokeColor=#d79b00;fillColor=#ffe6cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="125" y="530" width="180" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-31" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-22" target="TYA-corCzER_tpGZpnsk-24" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="330" y="480" as="sourcePoint" />
            <mxPoint x="330" y="600" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-5" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-36" target="TYA-corCzER_tpGZpnsk-46">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-36" value="No" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="690" y="610" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-44" value="" style="rhombus;whiteSpace=wrap;html=1;align=left;fillColor=#f8cecc;strokeColor=#b85450;" parent="1" vertex="1">
          <mxGeometry x="200" y="90" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-45" value="Stored Prodedure" style="text;html=1;strokeColor=#b85450;fillColor=#f8cecc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="240" y="95" width="120" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-27" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" parent="1" vertex="1">
          <mxGeometry x="315" y="525" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-48" value="&lt;b&gt;sp_i_tbl_unit_sla_season&lt;br&gt;&lt;/b&gt;" style="text;html=1;strokeColor=#b85450;fillColor=#f8cecc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="733" y="725" width="217" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-57" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-49" target="TYA-corCzER_tpGZpnsk-56" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-49" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;new record into tbl_unit_sla_season&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="630" y="840" width="200" height="50" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-63" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-56" target="TYA-corCzER_tpGZpnsk-62" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-56" value="&lt;span style=&quot;font-weight: normal&quot;&gt;Does a record for this unit exist in tbl_unit_sla_season?&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="940" y="840" width="190" height="50" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-65" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-56" target="TYA-corCzER_tpGZpnsk-64" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-70" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-62" target="TYA-corCzER_tpGZpnsk-69" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-62" value="&lt;span style=&quot;font-weight: normal&quot;&gt;No&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1;align=center;" parent="1" vertex="1">
          <mxGeometry x="1160" y="800" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-69" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;new record from tbl_change_request with&lt;br&gt;&lt;/span&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;- effective = 1&lt;br&gt;- effective_from to the next Sunday&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="1290" y="780" width="230" height="70" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-72" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" parent="1" source="TYA-corCzER_tpGZpnsk-64" edge="1">
          <mxGeometry relative="1" as="geometry">
            <mxPoint x="1290" y="915" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-64" value="&lt;span style=&quot;font-weight: normal&quot;&gt;Yes&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1;align=center;" parent="1" vertex="1">
          <mxGeometry x="1160" y="900" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-2" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-53" target="TYA-corCzER_tpGZpnsk-46">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-53" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" parent="1" vertex="1">
          <mxGeometry x="590" y="720" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-55" value="&lt;b&gt;trg_i_tbl_change_request_status&lt;/b&gt;" style="text;html=1;strokeColor=#d79b00;fillColor=#ffe6cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="380" y="730" width="200" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-67" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" parent="1" vertex="1">
          <mxGeometry x="870" y="848" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-68" value="&lt;b&gt;trg_i_tbl_unit_sla_season&lt;/b&gt;" style="text;html=1;strokeColor=#d79b00;fillColor=#ffe6cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="795" y="905" width="180" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-73" value="Update:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;existing record in tbl_unit_sla_season with&lt;/span&gt;&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;- effective to 0&lt;br&gt;- effective_to date to the next Saturday&lt;br&gt;&lt;br&gt;&lt;/span&gt;Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;new record from tbl_change_request with&lt;br&gt;&lt;/span&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;- effective = 1&lt;br&gt;- effective_from to the next Sunday&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="1290" y="891" width="280" height="150" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-6" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-46" target="TYA-corCzER_tpGZpnsk-49">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-46" value="" style="rhombus;whiteSpace=wrap;html=1;align=left;fillColor=#f8cecc;strokeColor=#b85450;" parent="1" vertex="1">
          <mxGeometry x="700" y="720" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-7" value="&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;&lt;b&gt;Insert:&lt;/b&gt;&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;new record into tbl_change_request_status with sla_change_status = 2 for &quot;approved&quot;&lt;/span&gt;&lt;/div&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="870" y="390" width="230" height="90" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
