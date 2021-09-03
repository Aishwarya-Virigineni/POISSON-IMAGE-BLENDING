function mask = mask_function(Image)

imshow(Image, []);
free_handle = imfreehand();

fcn = makeConstrainToRectFcn('impoly',get(gca,'XLim'),get(gca,'YLim'));
setPositionConstraintFcn(free_handle,fcn);

wait(free_handle);
mask = free_handle.createMask();