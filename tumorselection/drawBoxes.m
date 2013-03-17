
function drawBoxes(h,pos,color)
axes(h)
hold on
plot(h,[pos(3) pos(4) pos(4) pos(3 ) pos(3)],[pos(1) pos(1) pos(2) pos(2) pos(1)],'color',color,'linestyle','-','linewidth',3);
hold off