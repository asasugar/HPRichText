import { HPRichText_1, RichTextOption } from '@ohasasugar/hp-richtext';

@Entry
@Component
struct Index {
  @State richTextOption: RichTextOption = {
    content: `
<div class="view-fullmodle">
  <a
    class="confirm-btn mb10"
    ttname="bbs_detail_onlylzpic"
    href="https://jiaxing.19lou.com/creampic-fid-779-t-97041711089344239-p-97731711089344480-nodigest-all-dateline.html"
    ><span>只看楼主大图</span></a
  >
</div>
<div>
<div>
    今天是南湖天地咖啡节第一天，中午就跟小伙伴噶闹忙去了。今年品牌明显多了，一时都不知道应该喝哪几家，随意感受了一下。<br /><br />先说，不爱咖啡的小伙伴谨慎冲。场地很小，人超多，人气旺的摊位都要排队。价格不便宜，一般都是38-48元的价位。<br /><br />第一家喝了云南的谙客咖啡，这家去年就在。还记得去年我喝的是“有风在大理”，去年要68元，今年还有，只要48元了，伤心。今年的新品是“繁花”，依然是68元。节省的我选了非新品“菇的咖啡”，48元，大致是菌菇风味的底+朗姆酒+啤酒花的沫，整体野生菌味很明显，我挺爱的，但是我的小伙伴们没一个爱菇味。买一杯咖啡，就送了包包和贴纸，好感度拉满。<img
      src="https://att2.citysbs.com/jiaxing/2024/03/22/14/middle_2852x2363-143517_v3_12591711089317660_6c54216859ffc3fd36822ac28584b420.jpg"
      data-filename="/2024/03/22/14/middle_2852x2363-143517_v3_12591711089317660_6c54216859ffc3fd36822ac28584b420.jpg"
      data-source="attach"
      border="0"
      alt="南湖天地咖啡节噶闹忙 各种特调和手冲多的喝不过来"
      referrerpolicy="no-referrer"
    />
  </div>
  <div><br /></div>
  <div>
    <img
      src="https://att2.citysbs.com/jiaxing/2024/03/22/14/middle_2700x3012-143517_v3_17451711089318007_c776635789c2912a64c34bfdc0d7d516.jpg"
      data-filename="/2024/03/22/14/middle_2700x3012-143517_v3_17451711089318007_c776635789c2912a64c34bfdc0d7d516.jpg"
      data-source="attach"
      border="0"
      alt="南湖天地咖啡节噶闹忙 各种特调和手冲多的喝不过来"
      referrerpolicy="no-referrer"
    />
  </div>
  <div><br /></div>
   <div>
    <img
      src="https://att2.citysbs.com/jiaxing/2024/03/22/14/middle_4096x5461-143536_v3_20191711089341180_f63d670a1adef88fca9934bea4f6d92f.jpg"
      data-filename="/2024/03/22/14/middle_4096x5461-143536_v3_20191711089341180_f63d670a1adef88fca9934bea4f6d92f.jpg"
      data-source="attach"
      border="0"
      alt="南湖天地咖啡节噶闹忙 各种特调和手冲多的喝不过来"
      referrerpolicy="no-referrer"
    />
  </div>
  <div><br /></div>
  <div>
    <img
      src="https://att2.citysbs.com/jiaxing/2024/03/22/14/middle_4032x3024-143518_v3_12281711089318759_50040f301f3e70a67ca670916be22f6f.jpg"
      data-filename="/2024/03/22/14/middle_4032x3024-143518_v3_12281711089318759_50040f301f3e70a67ca670916be22f6f.jpg"
      data-source="attach"
      border="0"
      alt="南湖天地咖啡节噶闹忙 各种特调和手冲多的喝不过来"
      referrerpolicy="no-referrer"
    />
  </div>
  <div>
    <br />第二家喝了广州的&amp;U。我们人多，把“黑色森林”、“柏林少女”、“荔城挂绿”、“花园派对”都点了。个人口味比较喜欢黑色森林（液体巧克力蛋糕味）和荔城挂绿（很清爽）。
  </div>
  <div>
    <img
      src="https://att2.citysbs.com/jiaxing/2024/03/22/14/middle_4096x3483-143522_v3_17951711089322833_508c0acfee35f996fdf9fb7c0cf43d72.jpg"
      data-filename="/2024/03/22/14/middle_4096x3483-143522_v3_17951711089322833_508c0acfee35f996fdf9fb7c0cf43d72.jpg"
      data-source="attach"
      border="0"
      alt="南湖天地咖啡节噶闹忙 各种特调和手冲多的喝不过来"
      referrerpolicy="no-referrer"
    />
  </div>
  <div><br /></div>

    </div>
       `,
    imageProp: {
      webp: true,
    }
  };

  build() {
    Column() {
      HPRichText_1({
        richTextOption: $richTextOption,
        needScroll: true,
        onLinkPress: (e) => {
          return e;
        }
      })
    }
  }
}