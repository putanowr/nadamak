%% Illustrate how to to put labels at nodes, elements or arbitrary location 
%
[nodes, elements] = mp_mesh_factory('meshB');

figure(1);
clf;
ghandles = mp_plot_mesh(nodes, elements);
mp_plot_labels(ghandles.elements, struct('Color', 'red'));
mp_plot_labels(ghandles.nodes);
axis('equal')
saveas(gcf, 'demo_labels.png');
% Report demo status
mp_manage_demos('report', 'labels', true);
