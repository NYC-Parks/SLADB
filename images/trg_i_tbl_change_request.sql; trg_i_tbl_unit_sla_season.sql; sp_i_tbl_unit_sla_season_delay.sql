<mxfile host="app.diagrams.net" modified="2020-07-24T02:38:59.344Z" agent="5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36" etag="gAylFeEc317JYLCl-SVP" version="13.5.1" type="github">
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
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-2" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-7" target="TYA-corCzER_tpGZpnsk-22">
          <mxGeometry relative="1" as="geometry" />
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
        <mxCell id="TYA-corCzER_tpGZpnsk-9" value="COO Focht Reviews Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="270" y="270" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-25" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-27" target="TYA-corCzER_tpGZpnsk-24" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-1" value="" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-22" target="TYA-corCzER_tpGZpnsk-27">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-22" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;new record to tbl_change_request (which would include justification)&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="55" y="400" width="170" height="80" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-24" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;new record into tbl_change_request_status with &lt;br&gt;- sla_change_status = 1 for &quot;submitted&quot;&lt;br&gt;- status_date equal to the current date and time&lt;br&gt;- status_user to the user that submitted the request&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="55" y="615" width="278.75" height="105" as="geometry" />
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
        <mxCell id="utrAC_NS1D6aVvXHYf-W-10" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" parent="1" source="TYA-corCzER_tpGZpnsk-17" target="utrAC_NS1D6aVvXHYf-W-9" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-17" value="&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;&lt;b&gt;Insert:&lt;/b&gt;&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;new record into tbl_change_request_status with sla_change_status = 3 for &quot;rejected&quot;&lt;/span&gt;&lt;/div&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" parent="1" vertex="1">
          <mxGeometry x="800" y="190" width="230" height="90" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-8" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-14" target="utrAC_NS1D6aVvXHYf-W-7" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-14" value="Approve Request" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="600" y="320" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-24" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-32" target="TYA-corCzER_tpGZpnsk-36" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-30" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-32" target="TYA-corCzER_tpGZpnsk-39" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-32" value="Is the effective_start date equal to today&#39;s date minus 1 hour?" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="655" y="600" width="120" height="60" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-28" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-39" target="utrAC_NS1D6aVvXHYf-W-27" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-39" value="No" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="565" y="615" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-21" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-17" target="TYA-corCzER_tpGZpnsk-17" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-28" value="&lt;b&gt;trg_i_tbl_change_request.sql&lt;/b&gt;" style="text;html=1;strokeColor=#d79b00;fillColor=#ffe6cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="160" y="540" width="180" height="20" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-25" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-36" target="TYA-corCzER_tpGZpnsk-49" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-36" value="Yes" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" parent="1" vertex="1">
          <mxGeometry x="690" y="730" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-44" value="" style="rhombus;whiteSpace=wrap;html=1;align=left;fillColor=#f8cecc;strokeColor=#b85450;" parent="1" vertex="1">
          <mxGeometry x="200" y="90" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-45" value="Stored Prodedure" style="text;html=1;strokeColor=#b85450;fillColor=#f8cecc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="240" y="95" width="120" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-27" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" parent="1" vertex="1">
          <mxGeometry x="125" y="535" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-48" value="&lt;b&gt;sp_i_tbl_unit_sla_season&lt;br&gt;&lt;/b&gt;" style="text;html=1;strokeColor=#b85450;fillColor=#f8cecc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="608" y="450" width="214" height="20" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-4" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-49" target="TYA-corCzER_tpGZpnsk-67">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-49" value="Insert:&lt;br&gt;&lt;span style=&quot;font-weight: 400&quot;&gt;new record into tbl_unit_sla_season&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="615" y="840" width="200" height="50" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-15" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;entryPerimeter=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-62" target="Xcc2Si-ru2YFNp3SEIyi-3">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-62" value="&lt;span style=&quot;font-weight: normal&quot;&gt;No&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1;align=center;" parent="1" vertex="1">
          <mxGeometry x="105" y="850" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-11" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-64" target="TYA-corCzER_tpGZpnsk-73">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-64" value="&lt;span style=&quot;font-weight: normal&quot;&gt;Yes&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1;align=center;" parent="1" vertex="1">
          <mxGeometry x="290" y="950" width="50" height="30" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-21" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-53" target="TYA-corCzER_tpGZpnsk-46" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-53" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" parent="1" vertex="1">
          <mxGeometry x="900" y="475" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-55" value="&lt;b&gt;trg_i_tbl_change_request_status&lt;/b&gt;" style="text;html=1;strokeColor=#d79b00;fillColor=#ffe6cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="935" y="480" width="200" height="20" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-6" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;" edge="1" parent="1" source="TYA-corCzER_tpGZpnsk-67" target="Xcc2Si-ru2YFNp3SEIyi-5">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-67" value="" style="ellipse;whiteSpace=wrap;html=1;aspect=fixed;fillColor=#ffe6cc;strokeColor=#d79b00;" parent="1" vertex="1">
          <mxGeometry x="495" y="850" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-68" value="&lt;b&gt;trg_i_tbl_unit_sla_season&lt;/b&gt;" style="text;html=1;strokeColor=#d79b00;fillColor=#ffe6cc;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" parent="1" vertex="1">
          <mxGeometry x="420" y="826" width="180" height="20" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-73" value="Update:&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;existing record in tbl_unit_sla_season with the values&lt;/span&gt;&lt;br&gt;&lt;span style=&quot;font-weight: normal&quot;&gt;- effective = 0&lt;br&gt;- effective_end date equal to the current date&lt;br&gt;&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1;align=left;" parent="1" vertex="1">
          <mxGeometry x="395" y="920.25" width="230" height="89.5" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-22" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" parent="1" source="TYA-corCzER_tpGZpnsk-46" target="TYA-corCzER_tpGZpnsk-32" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="TYA-corCzER_tpGZpnsk-46" value="" style="rhombus;whiteSpace=wrap;html=1;align=left;fillColor=#f8cecc;strokeColor=#b85450;" parent="1" vertex="1">
          <mxGeometry x="700" y="475" width="30" height="30" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-13" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" parent="1" source="utrAC_NS1D6aVvXHYf-W-7" target="TYA-corCzER_tpGZpnsk-53" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-7" value="&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;&lt;b&gt;Insert:&lt;/b&gt;&lt;/span&gt;&lt;/div&gt;&lt;div style=&quot;text-align: left&quot;&gt;&lt;span&gt;new record into tbl_change_request_status with sla_change_status = 2 for &quot;approved&quot;&lt;/span&gt;&lt;/div&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" parent="1" vertex="1">
          <mxGeometry x="800" y="305" width="230" height="90" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-9" value="No Transaction Required" style="whiteSpace=wrap;html=1;shape=mxgraph.basic.octagon2;align=center;verticalAlign=middle;dx=15;fillColor=#fff2cc;strokeColor=#d6b656;" parent="1" vertex="1">
          <mxGeometry x="1090" y="185" width="100" height="100" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-29" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=1;exitY=0.5;exitDx=0;exitDy=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;" parent="1" source="utrAC_NS1D6aVvXHYf-W-27" target="TYA-corCzER_tpGZpnsk-46" edge="1">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="utrAC_NS1D6aVvXHYf-W-27" value="&lt;i&gt;In addition to being called by the trigger, this stored procedure is schedule to run once daily.&lt;/i&gt;" style="rounded=0;whiteSpace=wrap;html=1;" parent="1" vertex="1">
          <mxGeometry x="480" y="450" width="120" height="80" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-3" value="No Transaction Required" style="whiteSpace=wrap;html=1;shape=mxgraph.basic.octagon2;align=center;verticalAlign=middle;dx=15;fillColor=#fff2cc;strokeColor=#d6b656;direction=south;" vertex="1" parent="1">
          <mxGeometry x="80" y="909.75" width="100" height="100" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-10" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0.5;exitY=1;exitDx=0;exitDy=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;" edge="1" parent="1" source="Xcc2Si-ru2YFNp3SEIyi-5" target="TYA-corCzER_tpGZpnsk-64">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-13" style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;exitX=0;exitY=0.5;exitDx=0;exitDy=0;entryX=1;entryY=0.5;entryDx=0;entryDy=0;" edge="1" parent="1" source="Xcc2Si-ru2YFNp3SEIyi-5" target="TYA-corCzER_tpGZpnsk-62">
          <mxGeometry relative="1" as="geometry" />
        </mxCell>
        <mxCell id="Xcc2Si-ru2YFNp3SEIyi-5" value="&lt;span style=&quot;font-weight: 400 ; text-align: center&quot;&gt;Does tbl_unit_sla_season have a record for this unit with value of effective = 1?&lt;/span&gt;" style="rounded=0;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontStyle=1;align=left;" vertex="1" parent="1">
          <mxGeometry x="220" y="840" width="190" height="50" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
