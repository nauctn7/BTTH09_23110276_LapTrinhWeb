<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>Categories</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="p-4">
  <h3>Categories</h3>

  <!-- Back button -->
  <div class="mb-3">
    <button class="btn btn-secondary" onclick="window.location.href='/'">← Quay lại trang chủ</button>
  </div>

  <!-- Form -->
  <form class="row g-2 mb-3" onsubmit="return saveCategory(event)">
    <input type="hidden" id="catId"/>
    <div class="col-md-4">
      <input id="catName" class="form-control" placeholder="Name" required>
    </div>
    <div class="col-md-5">
      <input id="catImages" class="form-control" placeholder="Image URL">
    </div>
    <div class="col-md-3 d-grid">
      <button class="btn btn-success" type="submit">Save</button>
    </div>
  </form>

  <table class="table table-hover">
    <thead>
      <tr><th>#</th><th>Name</th><th>Images</th><th>Actions</th></tr>
    </thead>
    <tbody id="rows"></tbody>
  </table>

<script>
async function gql(query, variables = {}) {
  const res = await fetch('/graphql', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ query, variables })
  });
  let json;
  try { json = await res.json(); } catch(e) {
    alert('Không đọc được JSON từ /graphql'); return {};
  }
  if (json.errors) {
    alert(json.errors.map(e => e.message).join('\n'));
  }
  return json.data || {};
}

/* GraphQL */
const Q = `query { categories { id name images } }`;
const C = `mutation($input:CategoryInput!){
  createCategory(input:$input){ id name images }
}`;
const U = `mutation($id:ID!, $input:CategoryInput!){
  updateCategory(id:$id, input:$input){ id name images }
}`;
const D = `mutation($id:ID!){ deleteCategory(id:$id) }`;

/* Load list */
async function loadCategories(){
  const d = await gql(Q);
  const list = d.categories || [];
  const tb = document.getElementById('rows');
  tb.innerHTML = '';
  list.forEach((c,i)=>{
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${i+1}</td>
      <td>${c.name ?? ''}</td>
      <td>${c.images ?? ''}</td>
      <td>
        <button class="btn btn-sm btn-primary me-1"
                onclick='editCategory(${JSON.stringify(c).replaceAll("'","\\'")})'>Edit</button>
        <button class="btn btn-sm btn-danger"
                onclick="removeCategory('${c.id}')">Delete</button>
      </td>`;
    tb.appendChild(tr);
  });
}

/* Edit -> fill form */
function editCategory(c){
  document.getElementById('catId').value = c.id;
  document.getElementById('catName').value = c.name || '';
  document.getElementById('catImages').value = c.images || '';
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

/* Save (create/update) */
async function saveCategory(e){
  if (e) e.preventDefault(); // stop default submit

  const idEl = document.getElementById('catId');
  const nameEl = document.getElementById('catName');
  const imagesEl = document.getElementById('catImages');

  const input = {
    name: (nameEl.value || '').trim(),
    images: (imagesEl.value || '').trim()
  };
  if (!input.name) { alert('Name is required'); return false; }

  if (idEl.value) {
    await gql(U, { id: idEl.value, input });    // variables.input
  } else {
    await gql(C, { input });                     // variables.input
  }

  // reset form + reload
  idEl.value = '';
  nameEl.value = '';
  imagesEl.value = '';
  await loadCategories();
  return false; // also block page reload
}

/* Delete */
async function removeCategory(id){
  if (!confirm('Delete?')) return;
  await gql(D, { id });
  await loadCategories();
}

loadCategories();
</script>
</body>
</html>
