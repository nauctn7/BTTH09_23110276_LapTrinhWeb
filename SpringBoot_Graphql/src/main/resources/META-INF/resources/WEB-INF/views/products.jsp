<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html>
<head>
  <title>Products</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="p-4">
  <h3>Products</h3>

  <!-- Nút quay lại -->
  <div class="mb-3">
    <button class="btn btn-secondary" onclick="window.location.href='/'">← Quay lại trang chủ</button>
  </div>

  <!-- Form CRUD -->
  <form class="row g-2 mb-4" onsubmit="return save()">
    <input type="hidden" id="id"/>
    <div class="col-md-3"><input id="title" class="form-control" placeholder="Title" required></div>
    <div class="col-md-2"><input type="number" id="quantity" class="form-control" placeholder="Quantity"></div>
    <div class="col-md-2"><input type="number" id="price" class="form-control" placeholder="Price"></div>
    <div class="col-md-5"><input id="description" class="form-control" placeholder="Description"></div>
    <div class="col-md-3"><select id="userId" class="form-select" required></select></div>
    <div class="col-md-3"><select id="categoryId" class="form-select" required></select></div>
    <div class="col-md-2 d-grid"><button class="btn btn-success">Save</button></div>
  </form>

  <!-- Filter theo Category -->
  <div class="row g-2 mb-3">
    <div class="col-md-4">
      <select id="filterCategory" class="form-select">
        <option value="">-- All categories (sorted by price asc) --</option>
      </select>
    </div>
    <div class="col-md-2"><button class="btn btn-primary" onclick="load()">Load</button></div>
  </div>

  <table class="table table-hover">
    <thead><tr>
      <th>#</th><th>Title</th><th>Qty</th><th>Price</th><th>Category</th><th>User</th><th>Actions</th>
    </tr></thead>
    <tbody id="rows"></tbody>
  </table>

<script>
/* ===== Hàm gọi GraphQL ===== */
async function gql(query, variables = {}) {
  const res = await fetch('/graphql', {
    method: 'POST',
    headers: {'Content-Type': 'application/json'},
    body: JSON.stringify({query, variables})
  });
  const json = await res.json();
  if (json.errors) alert(json.errors.map(e => e.message).join('\n'));
  return json.data || {};
}

/* ===== Query/Mutation ===== */
const Q_USERS = `query { users { id fullname } }`;
const Q_CATS  = `query { categories { id name } }`;
const Q_LIST_ASC = `query { productsSortedByPriceAsc {
    id title quantity price description
    category { id name } user { id fullname }
  }}`;
const Q_BY_CAT = `query($cid:ID!){
  productsByCategory(categoryId:$cid){
    id title quantity price description
    category { id name } user { id fullname }
  }
}`;
const C = `mutation($in:ProductInput!){ createProduct(input:$in){ id } }`;
const U = `mutation($id:ID!, $in:ProductInput!){ updateProduct(id:$id, input:$in){ id } }`;
const D = `mutation($id:ID!){ deleteProduct(id:$id) }`;

/* ===== Load danh sách ===== */
async function initSelects(){
  const us = await gql(Q_USERS);
  const cs = await gql(Q_CATS);

  userId.innerHTML = '<option value="">-- User --</option>';
  (us.users||[]).forEach(u=> userId.innerHTML += `<option value="${u.id}">${u.fullname}</option>`);

  categoryId.innerHTML = '<option value="">-- Category --</option>';
  filterCategory.innerHTML = '<option value="">-- All categories (sorted by price asc) --</option>';
  (cs.categories||[]).forEach(c=>{
    categoryId.innerHTML   += `<option value="${c.id}">${c.name}</option>`;
    filterCategory.innerHTML+= `<option value="${c.id}">${c.name}</option>`;
  });
}

async function load(){
  const cid = filterCategory.value;
  const data = cid ? await gql(Q_BY_CAT,{cid}) : await gql(Q_LIST_ASC);
  const list = cid ? (data.productsByCategory||[]) : (data.productsSortedByPriceAsc||[]);

  rows.innerHTML = '';
  list.forEach((p,i)=>{
    rows.innerHTML += `
      <tr>
        <td>${i+1}</td>
        <td>${p.title??''}</td>
        <td>${p.quantity??''}</td>
        <td>${p.price??''}</td>
        <td>${p.category?.name??''}</td>
        <td>${p.user?.fullname??''}</td>
        <td>
          <button class="btn btn-sm btn-primary me-1" onclick='edit(${JSON.stringify(p).replaceAll("'","\\'")})'>Edit</button>
          <button class="btn btn-sm btn-danger" onclick="removeP('${p.id}')">Delete</button>
        </td>
      </tr>`;
  });
}

function edit(p){
  id.value=p.id; title.value=p.title||''; quantity.value=p.quantity||''; price.value=p.price||'';
  description.value=p.description||''; userId.value=p.user?.id||''; categoryId.value=p.category?.id||'';
  window.scrollTo({top:0,behavior:'smooth'});
}

async function save(){
  const inPayload={
    title:title.value.trim(),
    quantity: quantity.value?parseInt(quantity.value,10):null,
    description:description.value.trim(),
    price: price.value?parseFloat(price.value):null,
    userId:userId.value,
    categoryId:categoryId.value
  };
  if(id.value) await gql(U,{id:id.value,in:inPayload}); else await gql(C,{in:inPayload});
  id.value=''; title.value=''; quantity.value=''; price.value=''; description.value='';
  userId.value=''; categoryId.value='';
  await load();
  return false;
}

async function removeP(pid){ if(confirm('Delete?')){ await gql(D,{id:pid}); await load(); } }

initSelects().then(load);
</script>
</body>
</html>
