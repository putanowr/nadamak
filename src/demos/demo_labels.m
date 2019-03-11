%% Illustrate how to to put labels at nodes, elements or arbitrary location 
%
[nodes, elements] = mp_mesh_factory('meshB');

figure(1);
clf;
ghandles = mp_plot_mesh(gac, nodes, elements);
mp_plot_labels(gca, ghandles.elements, struct('Color', 'red'));
mp_plot_labels(gca, ghandles.nodes);
axis('equal')
saveas(gcf, 'demo_labels.png');
% Report demo status
mp_manage_demos('report', 'labels', true);
