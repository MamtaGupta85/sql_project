create database insurance_claims;

select * from customers;
select * from agents;
select * from vendor;

-- the total average premium paid and claim made by the customers for each insurance type
select insurance_type, avg(premium_amount) as average_premium, avg(claim_amount) as average_claim
from customers
group by insurance_type;


-- the range of premiums and claims 
select insurance_type, concat(min(premium_amount), '- ', max(premium_amount)) as premium_range, 
concat(min(claim_amount), ' - ', max(claim_amount)) as claim_range
from customers 
group by insurance_type;


-- find that insurance type which has the maximum total premium.
select INSURANCE_TYPE, sum(premium_amount) as total_premium
from customers
group by insurance_type
having total_premium > avg(premium_amount)
limit 1;

-- most popular insurance type within the age bracket of 18-30 years
select insurance_type, count(customer_id) as no_customers
from customers 
where age between 18 and 30
group by insurance_type
limit 1;

-- data of those agents which are not assigned with any claim management
select agent_id, agent_name, city, state, EMP_ACCT_NUMBER
from agents 
where agent_id NOT IN (select AGENT_ID from customers);


-- data of those  vendors who are not assigned with any claim investigation
select vendor_id, vendor_name, city, state
from vendor
where VENDOR_ID NOT IN (select vendor_id from customers);


-- query to find top five states which are incident prone.
select incident_state, count(*) as total_cases
from customers
group by incident_state
limit 5;


-- query to find those policies which are paid within 30 days from date of report
select policy_number, customer_name, INSURANCE_TYPE
from customers 
where datediff(TXN_DATE,REPORT_DT)<= 30 and claim_status= 'A';


-- policies which are reported within 200 days of D.O.E and are accepted claims.
select policy_number, customer_name, INSURANCE_TYPE
from customers
where CLAIM_STATUS= 'A' and datediff(REPORT_DT,POLICY_EFF_DT)<=200;


-- retreive the data of the claims which were at low risk but turned out total loss within 200 days.
select customer_id, customer_name, policy_number, insurance_type
from customers
where RISK_SEGMENTATION= 'L' AND INCIDENT_SEVERITY= 'Major Loss' and datediff(TXN_DATE, POLICY_EFF_DT)<=200;


-- total premium collected by each agent for health insurance.
select c.agent_id, a.AGENT_NAME, sum(c.premium_amount) as total_premium
from customers c
inner join agents a 
on c.AGENT_ID= a.AGENT_ID
where c.INSURANCE_TYPE= 'health'
group by c.agent_id, a.AGENT_NAME;


-- total number of reports handled by each agent. 
select c.agent_id, a.agent_name, c.INCIDENT_CITY, count(c.CUSTOMER_ID) as total_cases
from agents a  
right join customers c  
on a.AGENT_ID= c.AGENT_ID
group by c.AGENT_ID, c.INCIDENT_CITY
order by total_cases desc;


-- retrieve the data of top 5 agents who have handled the maximum life insurance claims.
select a.agent_id, a.agent_name, count(c.AGENT_ID) as total_cases
from customers c
right join agents a
on c.AGENT_ID = a.agent_id
where c.INSURANCE_TYPE= 'life'
group by a.agent_id 
order by total_cases desc
limit 5;

-- retreive the data of top 10 vendors who assisted in the 'Major loss' incident severity claims in VT state.
select v.vendor_id, v.vendor_name, count(c.vendor_id) as cases_handled
from customers c 
right join vendor v
on c.VENDOR_ID= v.VENDOR_ID
where c.INCIDENT_SEVERITY= 'Major Loss' and INCIDENT_STATE= 'VT' 
group by c.VENDOR_ID
order by cases_handled desc
limit 10;

-- retreive the data of the states which are not handled by any agent
select c.incident_city, c.INSURANCE_TYPE, c.INCIDENT_STATE
from customers c 
left join vendor v
on v.VENDOR_ID= c.VENDOR_ID
where v.VENDOR_ID  IS NULL  and v.vendor_name IS NULL;

-- retreive the number of customers in the age bracket of 18-30,31-50,51-80 for each insurance type
select insurance_type, 
count( distinct case when age between 18 and 30 then customer_id else 0 end) as '18-30',
count( distinct case when age between 31 and 50 then customer_id else 0 end) as '31-50',
count( distinct case when age between 51 and 80 then customer_id else 0 end) as '51-80'
from customers
group by INSURANCE_TYPE;




